// lib/features/itineraries/widgets/itinerary_card.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/itinerary_model.dart';
// Para formatear fechas de forma legible
import 'package:intl/intl.dart';

class ItineraryCard extends StatelessWidget {
  final Itinerary itinerary;

  const ItineraryCard({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    // Formateador para mostrar las fechas de forma amigable
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final String dateRange = '${formatter.format(itinerary.startDate)} - ${formatter.format(itinerary.endDate)}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // TODO: Navegar a la pantalla de detalle del itinerario
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itinerary.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(dateRange, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 4),
              if (itinerary.generatedByAi)
                Chip(
                  avatar: Icon(Icons.auto_awesome, size: 16, color: Theme.of(context).primaryColor),
                  label: const Text('Generado con IA'),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}