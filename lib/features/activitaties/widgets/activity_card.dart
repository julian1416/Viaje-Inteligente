// lib/features/activities/widgets/activity_card.dart

import 'package:flutter/material.dart';
import 'package:viajes_ai/api/models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Imagen de la actividad
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  activity.imageUrl ?? 'https://via.placeholder.com/100x80?text=Actividad',
                  height: 80,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 80,
                    width: 100,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rate_rounded, color: Colors.amber[600], size: 16),
                        // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
                        Text('${activity.rating.toStringAsFixed(1)} (${activity.numReviews})'),
                        const Spacer(),
                        Text(
                          '${activity.currency} ${activity.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}