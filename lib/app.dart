// lib/app.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viajes_ai/auth/auth_screen.dart';
import 'package:viajes_ai/features/home/home_screen.dart';
import 'package:viajes_ai/common/constants.dart';
import 'package:viajes_ai/core/app_theme.dart'; // <-- ¡Importamos nuestro tema!

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViajaInteligente AI',
      debugShowCheckedModeBanner: false,
      
      // --- APLICAMOS EL NUEVO TEMA OSCURO ---
      theme: AppTheme.darkTheme,
      
      home: StreamBuilder<AuthState>(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final Session? session = snapshot.data?.session;
          if (session == null) {
            return const AuthScreen();
          } else {
            return const HomeScreen(); // Ahora HomeScreen tendrá la barra de navegación
          }
        },
      ),
    );
  }
}