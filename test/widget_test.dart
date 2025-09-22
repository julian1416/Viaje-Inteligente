// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// PASO 1: AÑADE ESTOS DOS IMPORTS
import 'package:viajes_ai/app.dart'; 
import 'package:viajes_ai/auth/auth_screen.dart'; // O la pantalla que quieras probar


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // PASO 2: CORRIGE ESTA LÍNEA
    // Construye la app con una pantalla inicial, como lo harías en main.dart
    await tester.pumpWidget(const MyApp());

    // El resto de este test fallará porque tu app no es un contador,
    // pero el error de compilación desaparecerá. Puedes borrar estas líneas.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}