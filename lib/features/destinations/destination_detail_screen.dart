// lib/features/destinations/destination_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/activity_model.dart';
import 'package:viajes_ai/api/models/destination_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/common/widgets/loading_indicator.dart';
import 'package:viajes_ai/features/activitaties/activity_detail_screen.dart';
import 'package:viajes_ai/features/activitaties/widgets/activity_card.dart';

class DestinationDetailScreen extends StatefulWidget {
  final String destinationId;

  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<Destination?> _destinationFuture;
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _destinationFuture = _supabaseService.getDestinationById(widget.destinationId);
    _activitiesFuture = _supabaseService.getActivitiesForDestination(widget.destinationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Destination?>(
        future: _destinationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Error al cargar el destino.'));
          }

          final destination = snapshot.data!;

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(destination),
              _buildDestinationInfo(destination),
              _buildActivitiesHeader(),
              _buildActivitiesList(),
            ],
          );
        },
      ),
    );
  }

  // --- Widgets de construcción de la UI ---

  SliverAppBar _buildSliverAppBar(Destination destination) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(destination.name, style: const TextStyle(fontSize: 16.0)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              destination.imageUrl ?? 'https://via.placeholder.com/400x250?text=No+Image',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, color: Colors.white)),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDestinationInfo(Destination destination) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination.country,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 32),
            Text(
              'Sobre ${destination.name}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              destination.description ?? 'No hay descripción disponible.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildActivitiesHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Text(
          'Actividades Populares',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Este widget ahora es el encargado de pasar la señal de éxito hacia atrás
  Widget _buildActivitiesList() {
    return FutureBuilder<List<Activity>>(
      future: _activitiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(40.0), child: LoadingIndicator()));
        }
        if (snapshot.hasError) {
          return SliverToBoxAdapter(child: Center(child: Text('${snapshot.error}')));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('No hay actividades disponibles para este destino.')),
            ),
          );
        }

        final activities = snapshot.data!;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final activity = activities[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ActivityCard(
                  activity: activity,
                  // --- ¡LÓGICA ACTUALIZADA AQUÍ! ---
                  onTap: () async {
                    // Navegamos a la pantalla de detalle y esperamos un resultado.
                    final bool? bookingSuccess = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityDetailScreen(activityId: activity.id),
                      ),
                    );

                    // Si el resultado de la pantalla es 'true', significa que la reserva
                    // fue exitosa, por lo que cerramos esta pantalla también y le pasamos
                    // la señal 'true' a la pantalla anterior (la HomeScreen).
                    if (bookingSuccess == true && mounted) {
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              );
            },
            childCount: activities.length,
          ),
        );
      },
    );
  }
}