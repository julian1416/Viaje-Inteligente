// lib/api/models/booking_model.dart

class Booking {
  // Hacemos id y createdAt opcionales (nulables)
  final String? id;
  final String userId;
  final String activityId;
  final DateTime bookingDate;
  final DateTime activityStartDate;
  final int numTravelers;
  final double totalPrice;
  final String status;
  // Hacemos createdAt opcional
  final DateTime? createdAt;

  Booking({
    this.id, // Ahora es opcional
    required this.userId,
    required this.activityId,
    required this.bookingDate,
    required this.activityStartDate,
    required this.numTravelers,
    required this.totalPrice,
    this.status = 'confirmed', // Damos un valor por defecto
    this.createdAt, // Ahora es opcional
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      activityId: json['activity_id'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      activityStartDate: DateTime.parse(json['activity_start_date'] as String),
      numTravelers: json['num_travelers'] as int,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // No necesitamos enviar id ni createdAt al crear una nueva reserva
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'activity_id': activityId,
      'booking_date': bookingDate.toIso8601String(),
      'activity_start_date': activityStartDate.toIso8601String(),
      'num_travelers': numTravelers,
      'total_price': totalPrice,
      'status': status,
    };
  }
}