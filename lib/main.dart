import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:viajes_ai/app.dart';
import 'package:viajes_ai/common/constants.dart'; // donde defines `supabase`
import 'package:viajes_ai/auth/auth_screen.dart';
import 'package:viajes_ai/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Inicializa Supabase usando las variables de entorno
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}
