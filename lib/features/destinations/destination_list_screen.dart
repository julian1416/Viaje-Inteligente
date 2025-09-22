// lib/features/destinations/destination_list_screen.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/destination_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/common/widgets/loading_indicator.dart';
import 'package:viajes_ai/features/destinations/destination_detail_screen.dart';
import 'package:viajes_ai/features/home/widgets/destination_card.dart';

class DestinationListScreen extends StatefulWidget {
  const DestinationListScreen({super.key});

  @override
  State<DestinationListScreen> createState() => _DestinationListScreenState();
}

class _DestinationListScreenState extends State<DestinationListScreen> {
  late Future<List<Destination>> _destinationsFuture;
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _destinationsFuture = _supabaseService.getDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos los Destinos'),
      ),
      body: FutureBuilder<List<Destination>>(
        future: _destinationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron destinos.'));
          }

          final destinations = snapshot.data!;
          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return DestinationCard(
                destination: destination,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationDetailScreen(
                        destinationId: destination.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}