// lib/api/models/itinerary_model.dart

class Itinerary {
  final String? id;
  final String userId;
  final String? destinationId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool generatedByAi;
  final Map<String, dynamic> content; // Para el JSONB
  final DateTime? createdAt;

  Itinerary({
    this.id,
    required this.userId,
    this.destinationId,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.generatedByAi = false, // Valor por defecto
    required this.content,
    this.createdAt,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      userId: json['user_id'],
      destinationId: json['destination_id'],
      name: json['name'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      generatedByAi: json['generated_by_ai'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'destination_id': destinationId,
      'name': name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'generated_by_ai': generatedByAi,
      'content': content,
    };
  }
}