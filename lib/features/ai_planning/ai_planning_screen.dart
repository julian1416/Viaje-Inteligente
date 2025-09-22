// lib/features/ai_planning/ai_planning_screen.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/gemini_service.dart'; // <-- ¡Usamos nuestro nuevo servicio!
import 'package:viajes_ai/api/models/itinerary_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/common/constants.dart';

class AiPlanningScreen extends StatefulWidget {
  const AiPlanningScreen({super.key});

  @override
  State<AiPlanningScreen> createState() => _AiPlanningScreenState();
}

class _AiPlanningScreenState extends State<AiPlanningScreen> {
  final _promptController = TextEditingController();
  final GeminiService _geminiService = GeminiService(); // <-- Instanciamos el servicio
  final SupabaseService _supabaseService = SupabaseService();

  bool _isLoading = false;
  String? _aiResponse;
  String? _lastPrompt; // Para mostrar en el encabezado del resultado

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generateItinerary() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, describe tu viaje.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _lastPrompt = _promptController.text;
      _aiResponse = null;
    });

    try {
      // --- ¡LÓGICA REAL DE LA IA! ---
      final generatedText = await _geminiService.generateItinerary(_promptController.text);

      setState(() {
        _aiResponse = generatedText;
      });

      // --- Guardado en Supabase (simplificado) ---
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        // Creamos un nombre corto para el itinerario
        final itineraryName = _promptController.text.length > 50
            ? _promptController.text.substring(0, 47) + '...'
            : _promptController.text;

        final newItinerary = Itinerary(
          userId: userId,
          name: itineraryName,
          // Fechas de ejemplo, podrías hacer que la IA las sugiera también
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 3)), 
          generatedByAi: true,
          content: {'itinerary_text': generatedText},
        );
        await _supabaseService.saveItinerary(newItinerary);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Itinerario generado y guardado en "Mis Próximas Aventuras".'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiResponse = 'Error al generar el itinerario:\n\n${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificación con IA'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- UI REDiseñada ---
            Text(
              'Describe tu viaje ideal',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              '(ej. "Un viaje de 5 días a París para una pareja, con enfoque en arte y comida, presupuesto medio")',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribe aquí tu petición...',
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateItinerary,
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black),
                    )
                  : const Text('Generar Itinerario'),
            ),
            const SizedBox(height: 32),

            // --- SECCIÓN DE RESULTADO ---
            // Solo se muestra si hay una respuesta (o un error)
            if (_aiResponse != null)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_lastPrompt != null) ...[
                      Text(
                        'Aquí está un posible itinerario para "$_lastPrompt":',
                        style: theme.textTheme.titleMedium,
                      ),
                      const Divider(height: 24),
                    ],
                    Text(
                      _aiResponse!,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}