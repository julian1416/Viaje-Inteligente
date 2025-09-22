// lib/api/models/destination_model.dart

// Importa flutter/material si el modelo necesita interactuar con widgets
// o tipos de Flutter, aunque para un modelo puro de datos no es estrictamente necesario.
// Para este proyecto, lo mantenemos puramente de datos.

class Destination {
  final String id;
  final String name;
  final String country;
  final String? description;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final double avgRating;
  final int numReviews;
  final List<String>? popularActivities; // Tipo correcto para el array de strings

  Destination({
    required this.id,
    required this.name,
    required this.country,
    this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.avgRating = 0.0, // Valores por defecto en el constructor
    this.numReviews = 0, // Valores por defecto en el constructor
    this.popularActivities,
  });

  // Constructor factory para crear un objeto Destination desde un Map (JSON de Supabase)
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?, // Asegúrate que el nombre de la columna en Supabase es 'image_url'
      latitude: (json['latitude'] as num?)?.toDouble(), // Puede ser nulo, mapea de num a double
      longitude: (json['longitude'] as num?)?.toDouble(), // Puede ser nulo, mapea de num a double
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0, // Si es nulo, usa 0.0
      numReviews: (json['num_reviews'] as int?) ?? 0, // Si es nulo, usa 0
      popularActivities: (json['popular_activities'] as List<dynamic>?) // Cast a List<dynamic> primero
          ?.map((e) => e.toString()) // Luego mapea cada elemento a String
          .toList(), // Convierte a List<String>
    );
  }

  // Método para convertir un objeto Destination a un Map (para insertar/actualizar en Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'description': description,
      'image_url': imageUrl, // Asegúrate que el nombre de la columna en Supabase es 'image_url'
      'latitude': latitude,
      'longitude': longitude,
      'avg_rating': avgRating,
      'num_reviews': numReviews,
      'popular_activities': popularActivities,
    };
  }
}