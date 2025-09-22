// lib/api/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viajes_ai/api/models/activity_model.dart';
import 'package:viajes_ai/api/models/destination_model.dart';
import 'package:viajes_ai/api/models/itinerary_model.dart';
import 'package:viajes_ai/api/models/profile_model.dart';
import 'package:viajes_ai/api/models/booking_model.dart';
import 'package:viajes_ai/common/constants.dart';
import 'package:flutter/foundation.dart'; // Importante para debugPrint

class SupabaseService {
  // --- Métodos para Destinos ---
  Future<List<Destination>> getDestinations() async {
    try {
      final response = await supabase.from('destinations').select('*').order('name', ascending: true);
      debugPrint('Respuesta CRUDA de Supabase para destinos: $response'); // Debug
      final destinations = response.map((item) => Destination.fromJson(item as Map<String, dynamic>)).toList();
      return destinations;
    } on PostgrestException catch (error) {
      debugPrint('Error al obtener destinos (Supabase): ${error.message}');
      throw 'No se pudieron cargar los destinos. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al obtener destinos: $error');
      throw 'Ocurrió un error inesperado al cargar los destinos.';
    }
  }

  Future<Destination> getDestinationById(String id) async {
    try {
      final response = await supabase.from('destinations').select('*').eq('id', id).single();
      return Destination.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (error) {
      debugPrint('Error al obtener detalle del destino (Supabase): ${error.message}');
      throw 'No se pudo cargar el detalle del destino.';
    } catch (error) {
      debugPrint('Error genérico al obtener detalle del destino: $error');
      throw 'Ocurrió un error inesperado.';
    }
  }

  // --- Métodos para Actividades ---
  Future<List<Activity>> getActivitiesForDestination(String destinationId) async {
    try {
      final response = await supabase.from('activities').select('*').eq('destination_id', destinationId).order('name', ascending: true);
      final activities = response.map((item) => Activity.fromJson(item as Map<String, dynamic>)).toList();
      return activities;
    } on PostgrestException catch (error) {
      debugPrint('Error al obtener actividades (Supabase): ${error.message}');
      throw 'No se pudieron cargar las actividades.';
    } catch (error) {
      debugPrint('Error genérico al obtener actividades: $error');
      throw 'Ocurrió un error inesperado.';
    }
  }

  Future<Activity?> getActivityById(String id) async {
    try {
      final response = await supabase.from('activities').select('*').eq('id', id).single();
      return Activity.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST204' || error.message.contains('0 rows')) {
        debugPrint('Actividad con ID $id no encontrada.');
        return null;
      }
      debugPrint('Error al obtener actividad por ID (Supabase): ${error.message}, Code: ${error.code}');
      throw 'No se pudo cargar la actividad. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al obtener actividad por ID: $error');
      throw 'Ocurrió un error inesperado al cargar la actividad.';
    }
  }

  // --- Métodos para Perfiles (Profiles) ---
  Future<Profile?> getProfile(String userId) async {
    debugPrint('Intentando obtener perfil para userId: $userId'); // Debug
    try {
      final response = await supabase.from('profiles').select('*').eq('id', userId).single();
      debugPrint('Perfil encontrado para userId $userId: $response'); // Debug
      return Profile.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST204' || error.message.contains('0 rows')) { // 204 = No Content, o mensaje de "0 rows"
        debugPrint('Perfil con ID $userId no encontrado (PostgrestException).'); // Debug
        return null; // Este es el comportamiento esperado si no hay perfil
      }
      debugPrint('Error Postgrest al obtener perfil para $userId: ${error.message}, Code: ${error.code}'); // Debug
      throw 'No se pudo cargar la información de tu perfil.';
    } catch (error) {
      debugPrint('Error genérico al obtener perfil para $userId: $error'); // Debug
      throw 'Ocurrió un error inesperado al cargar el perfil.';
    }
  }

  Future<void> createProfile(String userId, String email) async {
    debugPrint('Intentando crear perfil para userId: $userId, email: $email'); // Debug
    try {
      await supabase.from('profiles').insert({
        'id': userId,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
      debugPrint('Perfil creado exitosamente para userId: $userId'); // Debug
    } on PostgrestException catch (error) {
      debugPrint('Error Postgrest al crear perfil para $userId: ${error.message}, Code: ${error.code}'); // Debug
      throw 'No se pudo crear tu perfil. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al crear perfil para $userId: $error'); // Debug
      throw 'Ocurrió un error inesperado al crear el perfil.';
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      await supabase.from('profiles').update({
        'username': username,
        'avatar_url': avatarUrl,
        'preferences': preferences,
      }).eq('id', userId);
    } on PostgrestException catch (error) {
      debugPrint('Error al actualizar perfil (Supabase): ${error.message}');
      throw 'No se pudo actualizar tu perfil. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al actualizar perfil: $error');
      throw 'Ocurrió un error inesperado al actualizar el perfil.';
    }
  }

  // --- Métodos para Itinerarios ---
  Future<List<Itinerary>> getItinerariesForUser(String userId) async {
    try {
      final response = await supabase
          .from('itineraries')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final itineraries = response.map((item) => Itinerary.fromJson(item as Map<String, dynamic>)).toList();
      return itineraries;
    } on PostgrestException catch (error) {
      debugPrint('Error al obtener itinerarios (Supabase): ${error.message}');
      throw 'No se pudieron cargar tus viajes.';
    } catch (error) {
      debugPrint('Error genérico al obtener itinerarios: $error');
      throw 'Ocurrió un error inesperado al cargar tus planes de viaje.';
    }
  }

  Future<Itinerary> saveItinerary(Itinerary itinerary) async {
    try {
      final response = await supabase
          .from('itineraries')
          .insert(itinerary.toJson())
          .select()
          .single();

      return Itinerary.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (error) {
      debugPrint('Error al guardar itinerario (Supabase): ${error.message}');
      throw 'No se pudo guardar el itinerario. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al guardar itinerario: $error');
      throw 'Ocurrió un error inesperado al guardar el plan de viaje.';
    }
  }

  // --- Métodos para Reservas (Bookings) ---
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final response = await supabase.from('bookings').select('*').eq('user_id', userId).order('activity_start_date', ascending: true);
      final bookings = response.map((item) => Booking.fromJson(item as Map<String, dynamic>)).toList();
      return bookings;
    } on PostgrestException catch (error) {
      debugPrint('Error al obtener reservas (Supabase): ${error.message}');
      throw 'No se pudieron cargar tus reservas. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al obtener reservas: $error');
      throw 'Ocurrió un error inesperado al cargar tus reservas.';
    }
  }

  Future<Booking> createBooking(Booking booking) async {
    try {
      final response = await supabase
          .from('bookings')
          .insert(booking.toJson())
          .select()
          .single();

      return Booking.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (error) {
      debugPrint('Error al crear reserva (Supabase): ${error.message}');
      throw 'No se pudo crear la reserva. Error: ${error.message}';
    } catch (error) {
      debugPrint('Error genérico al crear reserva: $error');
      throw 'Ocurrió un error inesperado al crear la reserva.';
    }
  }

  // --- Integración con Gemini AI (Lógica a desarrollar aquí) ---
}