// lib/api/models/profile_model.dart

class Profile {
  final String id; // Vinculado a auth.users.id
  final String email;
  final String? username;
  final String? avatarUrl;
  final Map<String, dynamic>? preferences; // JSONB para preferencias de IA
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
    this.preferences,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id' no se envía en update, solo en create si es necesario (maneja Supabase)
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'preferences': preferences,
      'created_at': createdAt.toIso8601String(),
    };
  }
}