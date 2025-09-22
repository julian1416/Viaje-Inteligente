// lib/features/itineraries/itinerary_repository.dart

import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:viajes_ai/api/models/itinerary_model.dart'; // Para el modelo Itinerary
import 'package:viajes_ai/api/supabase_service.dart'; // Para interactuar con Supabase

class ItineraryRepository {
  final SupabaseService _supabaseService = SupabaseService();

  /// Crea y guarda un nuevo itinerario en la base de datos,
  /// utilizando el texto generado por la IA de Gemini.
  Future<Itinerary> createItineraryWithAI({
    required String generatedContentText, // El texto detallado generado por la IA
    required String userId, // ID del usuario que crea/guarda el itinerario
    String? destinationId, // ID del destino asociado (puede ser nulo)
    required String itineraryName, // Nombre/título que el usuario (o la IA) le da al itinerario
  }) async {
    // 1. Preparar el contenido del itinerario para guardarlo como JSONB en Supabase
    // En el futuro, podrías procesar 'generatedContentText' en una estructura más detallada (ej. lista de días, actividades).
    final contentJson = <String, dynamic>{
      'full_text_ai_response': generatedContentText,
      'days': [], // Placeholder para una estructura de días futura
    };

    try {
      // 2. Crear una instancia del objeto Itinerary con los datos necesarios
      final itineraryToSave = Itinerary(
        id: '', // Supabase generará el UUID automáticamente al insertar
        userId: userId,
        destinationId: destinationId, // Puede ser nulo
        name: itineraryName,
        startDate: DateTime.now(), // Usamos la fecha actual como placeholder por ahora
        endDate: DateTime.now().add(const Duration(days: 7)), // Ejemplo: 7 días de duración
        generatedByAi: true, // Este itinerario fue generado por IA
        content: contentJson, // El JSONB con el detalle del itinerario
        createdAt: DateTime.now(),
      );

      // 3. Guardar el nuevo itinerario en la base de datos a través de SupabaseService
      final newItinerary = await _supabaseService.saveItinerary(itineraryToSave);

      return newItinerary;
    } catch (e) {
      // Relanzamos el error para que la capa de UI pueda manejarlo y mostrar un mensaje al usuario
      debugPrint('Error al crear itinerario con IA en el repositorio: $e');
      rethrow; // Propaga la excepción original
    }
  }

  // --- Otros métodos relacionados con itinerarios podrían ir aquí ---
  // Future<List<Itinerary>> getUserItineraries(String userId) { ... }
  // Future<Itinerary> getItineraryById(String itineraryId) { ... }
  // Future<void> updateItinerary(Itinerary itinerary) { ... }
  // Future<void> deleteItinerary(String itineraryId) { ... }
}