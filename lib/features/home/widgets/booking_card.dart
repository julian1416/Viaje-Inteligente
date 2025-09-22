// lib/features/home/widgets/booking_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viajes_ai/api/models/booking_model.dart';

class HomeBookingCard extends StatelessWidget {
  final Booking booking;
  final String activityName;

  const HomeBookingCard({
    super.key,
    required this.booking,
    this.activityName = 'Actividad Reservada',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Formateador para mostrar la fecha de forma legible
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    final String activityDate = formatter.format(booking.activityStartDate);

    return Card(
      // Usamos el CardTheme que ya está definido en tu app_theme.dart
      margin: const EdgeInsets.only(right: 16.0),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 250, // Ancho fijo para las tarjetas del carrusel
        child: InkWell(
          onTap: () {
            // TODO: Navegar a la pantalla de detalle de la reserva
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sección superior con el nombre y la fecha
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activityName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: theme.primaryColor),
                        const SizedBox(width: 8),
                        Text(activityDate, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
                // Sección inferior con el número de viajeros
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${booking.numTravelers} Viajero${booking.numTravelers > 1 ? 's' : ''}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: theme.primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}