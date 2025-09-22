// lib/api/models/activity_model.dart

class Activity {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final String currency;
  final String duration;
  final double rating;
  final int numReviews;
  final String type;
  final bool isCancellable;
  final Map<String, dynamic>? availability;

  Activity({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    required this.currency,
    required this.duration,
    // --- CORRECCIÓN AQUÍ ---
    required this.rating,
    required this.numReviews,
    // ---------------------
    required this.type,
    required this.isCancellable,
    this.availability,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'] ?? 'Sin nombre',
      description: json['description'],
      imageUrl: json['image_url'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      duration: json['duration'] ?? 'N/A',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      numReviews: (json['num_reviews'] as num?)?.toInt() ?? 0,
      // ---------------------
      type: json['type'] ?? 'General',
      isCancellable: json['is_cancellable'] ?? false,
      availability: json['availability'],
    );
  }
}