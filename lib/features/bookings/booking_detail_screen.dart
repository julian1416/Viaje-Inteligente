// lib/features/bookings/booking_detail_screen.dart

import 'package:flutter/material.dart';

class BookingDetailScreen extends StatelessWidget {
  // En un caso real, pasarías el ID de la reserva y la cargarías.
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Reserva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.local_activity),
              title: Text('Tour por el Coliseo'),
              subtitle: Text('ID de Reserva: #12345XYZ'),
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Información del Viajero',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('- 2 Adultos'),
            const SizedBox(height: 16),
            Text(
              'Fecha y Hora',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('- 25 de Octubre, 2025 a las 10:00 AM'),
            const Spacer(),
            Card(
              color: Colors.green[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Tu reserva está confirmada. ¡Disfruta tu actividad!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}