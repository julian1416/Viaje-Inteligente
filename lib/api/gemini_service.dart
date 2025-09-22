// lib/api/gemini_service.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY']!;
  final String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';

  Future<String> generateItinerary(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_url?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          // Opcional: Configuraciones de seguridad para filtrar contenido
          "safetySettings": [
            {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Navegamos a través de la respuesta JSON para obtener el texto.
        // Se añade una verificación para evitar errores si la respuesta no es la esperada.
        final generatedText = body['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (generatedText != null) {
          return generatedText;
        } else {
          throw 'La respuesta de la API no contiene el texto esperado.';
        }
      } else {
        // Si el servidor responde con un error, lo mostramos.
        throw 'Error de la API: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('Error al generar itinerario con Gemini: $e');
      throw 'No se pudo generar el itinerario. Revisa tu conexión y la clave de API.';
    }
  }
}