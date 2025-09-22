// lib/features/itineraries/itinerary_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:viajes_ai/api/models/itinerary_model.dart';

class ItineraryDetailScreen extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryDetailScreen({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    // Extraemos el texto del JSON. Usamos un valor por defecto por si acaso.
    final itineraryText = itinerary.content['full_text'] as String? ?? 'No hay detalles disponibles.';

    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary.name),
      ),
      body: Markdown(
        // El widget Markdown se encarga de darle estilo al texto.
        data: itineraryText,
        padding: const EdgeInsets.all(16.0),
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          p: const TextStyle(fontSize: 16, height: 1.5),
          listBullet: const TextStyle(fontSize: 16),
          blockquoteDecoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}