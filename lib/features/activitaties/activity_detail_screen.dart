// lib/features/activities/activity_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/activity_model.dart';
import 'package:viajes_ai/api/supabase_service.dart';
import 'package:viajes_ai/common/widgets/loading_indicator.dart';
import 'package:viajes_ai/features/bookings/widgets/booking_bottom_sheet.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityId;
  const ActivityDetailScreen({super.key, required this.activityId});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<Activity?> _activityFuture;

  @override
  void initState() {
    super.initState();
    _activityFuture = _supabaseService.getActivityById(widget.activityId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Activity?>(
        future: _activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error ?? 'No se pudo cargar la actividad.'}'));
          }

          final activity = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                stretch: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        activity.imageUrl ?? 'https://via.placeholder.com/400x250?text=No+Image',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activity.name, style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoChip(context, Icons.schedule, activity.duration),
                          const SizedBox(width: 12),
                          _buildInfoChip(context, Icons.terrain, activity.type),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.star, color: theme.primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${activity.rating.toStringAsFixed(1)} (${activity.numReviews} reseñas)',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildSection(context, title: 'Sobre la actividad', content: activity.description),
                      const SizedBox(height: 24),
                      _buildSection(
                        context,
                        title: 'Disponibilidad',
                        content: activity.availability?['days']?.toString() ?? 'Consultar disponibilidad',
                      ),
                      const SizedBox(height: 40),
                      _buildBookingButton(context, activity),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      label: Text(text),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
    );
  }
  
  Widget _buildSection(BuildContext context, {required String title, String? content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          content ?? 'No hay información disponible.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildBookingButton(BuildContext context, Activity activity) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async{
          final bool? bookingSuccess = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => BookingBottomSheet(
              activity: activity,
              onBookingConfirmed: (){},
              ),
          );
          if(bookingSuccess == true && mounted){
            Navigator.of(context).pop(true);
          }
        },
        icon: const Icon(Icons.shopping_cart_outlined),
        label: Text('Reservar Ahora por ${activity.currency} ${activity.price.toStringAsFixed(2)}'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF673AB7),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}