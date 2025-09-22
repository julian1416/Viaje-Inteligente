// lib/core/app_router.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/auth/auth_screen.dart';
import 'package:viajes_ai/features/home/home_screen.dart';
import 'package:viajes_ai/features/profile/profile_screen.dart';

class AppRouter {
  // Nombres de las rutas para evitar errores de tipeo
  static const String authRoute = '/';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';

  /// Generador de rutas. Se puede usar con la propiedad `onGenerateRoute` de MaterialApp.
  /// Esto permite pasar argumentos a las pantallas de una manera más estructurada.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case authRoute:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      // Puedes añadir más rutas aquí, por ejemplo, para el detalle del destino:
      // case destinationDetailRoute:
      //   final String destinationId = settings.arguments as String;
      //   return MaterialPageRoute(builder: (_) => DestinationDetailScreen(destinationId: destinationId));

      default:
        // Si la ruta no se encuentra, mostramos una pantalla de error.
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No se encontró la ruta: ${settings.name}'),
            ),
          ),
        );
    }
  }
}