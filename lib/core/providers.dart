// lib/core/providers.dart

import 'package:flutter/material.dart';
// Para usar el ejemplo, necesitarías añadir `provider: ^6.0.0` a tu pubspec.yaml
// y luego ejecutar `flutter pub get`.

/*
 * ===========================================================================
 * GESTIÓN DE ESTADO EN FLUTTER
 * ===========================================================================
 *
 * ¿Por qué es necesario?
 * En apps complejas, pasar datos de una pantalla a otra (ej. el perfil del usuario)
 * puede volverse muy complicado. Un gestor de estado proporciona un lugar central
 * para almacenar y acceder a estos datos desde cualquier parte de la app de una
 * manera eficiente.
 *
 * Opciones Populares:
 * 1. Provider: Simple, fácil de aprender. Ideal para empezar.
 * 2. Riverpod: Una versión mejorada de Provider, más flexible y segura.
 * 3. BLoC: Muy robusto, ideal para apps grandes con lógica de negocio compleja.
 *
 * ===========================================================================
 * EJEMPLO CON PROVIDER (COMENTADO)
 * ===========================================================================
 * A continuación se muestra cómo podrías gestionar el perfil del usuario con Provider.
 */

// 1. EL MODELO DE DATOS (El estado que quieres compartir)
//    Ya tenemos nuestra clase `Profile` en `lib/api/models/profile_model.dart`.

// 2. EL NOTIFICADOR (La clase que gestiona el estado y notifica los cambios)
/*
class ProfileProvider extends ChangeNotifier {
  final _supabaseService = SupabaseService();
  Profile? _profile;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile(String userId) async {
    _isLoading = true;
    notifyListeners(); // Notifica a los widgets que estamos cargando

    try {
      _profile = await _supabaseService.getProfile(userId);
    } catch (e) {
      print(e); // Manejar el error apropiadamente
    }

    _isLoading = false;
    notifyListeners(); // Notifica que terminamos de cargar y actualiza la UI con los datos
  }

  Future<void> updateUsername(String userId, String newUsername) async {
    if (_profile != null) {
      await _supabaseService.updateProfile(userId: userId, username: newUsername);
      // Actualizamos el perfil localmente y notificamos
      _profile = Profile(
        id: _profile!.id,
        email: _profile!.email,
        username: newUsername,
        avatarUrl: _profile!.avatarUrl,
        preferences: _profile!.preferences,
      );
      notifyListeners();
    }
  }
}
*/

// 3. REGISTRAR EL PROVIDER
//    En tu archivo `main.dart`, envolverías `MyApp` así:
/*
import 'package:provider/provider.dart';

void main() async {
  // ... tu código de inicialización de Supabase ...
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // ... otros providers que necesites ...
      ],
      child: MyApp(initialScreen: initialScreen),
    ),
  );
}
*/

// 4. USAR EL PROVIDER EN LA UI (Ej. en ProfileScreen)
/*
@override
void initState() {
  super.initState();
  // Llamamos al método del provider para cargar los datos
  // `listen: false` es importante en initState
  final userId = supabase.auth.currentUser!.id;
  context.read<ProfileProvider>().fetchProfile(userId);
}

@override
Widget build(BuildContext context) {
  // Escuchamos los cambios en el provider
  final profileProvider = context.watch<ProfileProvider>();

  if (profileProvider.isLoading) {
    return LoadingIndicator();
  }

  final profile = profileProvider.profile;
  
  // ... construir la UI con los datos de `profile` ...
}
*/