// lib/features/itineraries/itinerary_planning_screen.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/destination_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/common/constants.dart';
import 'package:viajes_ai/features/itineraries/itinerary_repository.dart'; // Importar el repositorio
// import 'package:google_generative_ai/google_generative_ai.dart'; // Si usas el SDK oficial de Google para Gemini

class ItineraryPlanningScreen extends StatefulWidget {
  final Destination destination; // El destino sobre el que se va a planificar
  const ItineraryPlanningScreen({super.key, required this.destination});

  @override
  State<ItineraryPlanningScreen> createState() => _ItineraryPlanningScreenState();
}

class _ItineraryPlanningScreenState extends State<ItineraryPlanningScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ItineraryRepository _itineraryRepository = ItineraryRepository(); // Instanciar el repositorio
  final SupabaseService _supabaseService = SupabaseService(); // Para obtener el perfil
  String _aiResponseText = '';
  bool _isLoading = false;
  String _userPrompt = ''; // Para guardar el prompt del usuario
  String _itineraryName = ''; // Para guardar el nombre del itinerario
  String? _currentUserId; // Para guardar el ID del usuario actual

  // --- CONFIGURACIÓN DE GEMINI (Ejemplo, adapta con tu API Key y modelo) ---
  // Necesitarás añadir tu API Key de Gemini aquí o como variable de entorno
  // final String? _geminiApiKey = dotenv.env['GEMINI_API_KEY']; // Asumiendo que usas flutter_dotenv
  // late final GenerativeModel _geminiModel;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    // if (_geminiApiKey != null) {
    //   _geminiModel = GenerativeModel(
    //     model: 'gemini-1.5-flash-latest', // O el modelo de Gemini que prefieras
    //     apiKey: _geminiApiKey!,
    //   );
    // }
  }

  Future<void> _loadInitialData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.id;
        _itineraryName = 'Viaje a ${widget.destination.name}'; // Nombre por defecto
      });
      // Opcional: cargar preferencias del perfil para incluirlas en el prompt
      // final profile = await _supabaseService.getProfile(user.id);
      // ... usar profile.preferences ...
    } else {
      // Manejar el caso de que el usuario no esté logueado si esta pantalla requiere autenticación
      // Por ahora, solo debugPrint
      debugPrint('Usuario no logueado en la pantalla de planificación IA');
    }
  }

  Future<void> _generatePlan() async {
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe tus preferencias para el itinerario.')),
      );
      return;
    }
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se pudo obtener el ID del usuario.')),
      );
      return;
    }

    // if (_geminiApiKey == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('API Key de Gemini no configurada.')),
    //   );
    //   return;
    // }

    setState(() {
      _isLoading = true;
      _aiResponseText = 'Generando tu itinerario ideal para ${widget.destination.name}...';
      _userPrompt = _promptController.text; // Guarda el prompt del usuario
    });

    try {
      // 1. Crear un prompt más completo para la IA, incluyendo el destino y el prompt del usuario
      final fullPrompt = '''
      Crea un itinerario de viaje detallado para ${widget.destination.name}, ${widget.destination.country}.
      Aquí están las preferencias del viajero: $_userPrompt.
      Organiza el plan día por día. Sé creativo y sugiere actividades, lugares para comer y consejos de logística.
      La respuesta debe ser solo el itinerario en formato de texto claro o markdown.
      ''';

      // --- Lógica de llamada a Gemini 1.5 Flash aquí ---
      // final content = [Content.text(fullPrompt)];
      // final response = await _geminiModel.generateContent(content);
      // final generatedText = response.text ?? 'No se pudo generar el itinerario.';

      // Simulación de respuesta de IA (eliminar cuando integres Gemini real)
      await Future.delayed(const Duration(seconds: 4));
      final generatedText = '¡Claro! Aquí tienes un itinerario para tus preferencias en ${widget.destination.name}:\n\n'
          '**Día 1: Llegada y Exploración Cultural**\n'
          '- Mañana: Llegada, check-in. Visita el centro histórico.\n'
          '- Tarde: Visita a un museo importante.\n'
          '- Noche: Cena en un restaurante tradicional.\n\n'
          '**Día 2: Aventura y Vistas Panorámicas**\n'
          '- Mañana: Actividad al aire libre (ej. senderismo, paseo en barco).\n'
          '- Tarde: Visita a un mirador o sitio con vistas impresionantes.\n'
          '- Noche: Espectáculo o evento local.\n\n'
          '**Día 3: Gastronomía y Relajación**\n'
          '- Mañana: Tour gastronómico o clase de cocina.\n'
          '- Tarde: Tiempo libre para compras o relax en un café.\n'
          '- Noche: Cena de despedida en un lugar especial.\n\n'
          '¡Que disfrutes tu viaje!';

      setState(() {
        _aiResponseText = generatedText;
      });

      // 2. Guardar el nuevo itinerario en la base de datos usando el repositorio
      final newItinerary = await _itineraryRepository.createItineraryWithAI(
        generatedContentText: generatedText, // Usamos el texto generado por la IA
        userId: _currentUserId!,
        destinationId: widget.destination.id,
        itineraryName: _itineraryName, // Usamos el nombre por defecto o el que ponga el usuario
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Itinerario para ${newItinerary.name} creado con éxito!')),
        );
        Navigator.of(context).pop(); // Regresamos a la pantalla anterior
      }
    } catch (e) {
      debugPrint('Error en la generación del plan de IA: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el itinerario. $e')),
        );
      }
      setState(() {
        _aiResponseText = 'Error: No se pudo generar el itinerario. Por favor, inténtalo de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planificar con IA para ${widget.destination.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Describe tus preferencias de viaje (ej. "3 días de aventura, presupuesto bajo")',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _generatePlan,
                    child: const Text('Generar Itinerario con IA'),
                  ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_aiResponseText), // Muestra el texto generado
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}