// lib/auth/auth_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viajes_ai/common/constants.dart';
import 'package:viajes_ai/api/supabase_service.dart'; // Para crear el perfil

class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> signIn({required String email, required String password}) async {
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw 'Error desconocido al iniciar sesión.';
      }
      // Verificar y crear perfil si no existe
      await _checkAndCreateProfile(response.user!);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al iniciar sesión.';
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw 'Error desconocido al registrarse.';
      }
      // Crear perfil para el nuevo usuario
      await _supabaseService.createProfile(response.user!.id, response.user!.email!);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al registrarse.';
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al cerrar sesión.';
    }
  }

  Future<void> recoverPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al solicitar el restablecimiento de contraseña.';
    }
  }

  // Verifica si el perfil existe y si no, lo crea (para signIn)
  Future<void> _checkAndCreateProfile(User user) async {
    final profile = await _supabaseService.getProfile(user.id);
    if (profile == null) {
      await _supabaseService.createProfile(user.id, user.email!);
    }
  }
}