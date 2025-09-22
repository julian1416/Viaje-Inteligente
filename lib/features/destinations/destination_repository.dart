// lib/features/destinations/destination_repository.dart

import 'package:viajes_ai/api/models/activity_model.dart';
import 'package:viajes_ai/api/models/destination_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';

/// Un repositorio para gestionar los datos relacionados con los destinos.
/// Actúa como una capa intermedia entre la UI y el servicio de datos.
class DestinationRepository {
  final SupabaseService _supabaseService;

  // Se puede inyectar el servicio para facilitar las pruebas.
  DestinationRepository({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService();

  /// Obtiene todos los destinos.
  Future<List<Destination>> fetchAllDestinations() {
    // Por ahora, solo reenvía la llamada. En el futuro, podría añadir
    // lógica de caché aquí.
    return _supabaseService.getDestinations();
  }

  /// Obtiene un destino por su ID.
  Future<Destination> fetchDestinationById(String id) {
    return _supabaseService.getDestinationById(id);
  }

  /// Obtiene las actividades para un destino.
  Future<List<Activity>> fetchActivitiesForDestination(String destinationId) {
    return _supabaseService.getActivitiesForDestination(destinationId);
  }
}