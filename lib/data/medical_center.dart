import 'package:flutter/foundation.dart';

@immutable
class MedicalCenter {
  final String name;
  final String location;

  const MedicalCenter({
    required this.name,
    required this.location,
  });

  // Copy constructor
  MedicalCenter copyWith({
    String? name,
    String? location,
  }) {
    return MedicalCenter(
      name: name ?? this.name,
      location: location ?? this.location,
    );
  }

  // FromJson constructor with null safety and error handling
  factory MedicalCenter.fromJson(Map<String, dynamic> json) {
    try {
      return MedicalCenter(
        name: json['name'] as String? ?? '',
        location: json['location'] as String? ?? '',
      );
    } catch (e) {
      throw FormatException('Failed to load medical center: $e');
    }
  }

  // ToJson method
  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
  };

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MedicalCenter &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              location == other.location;

  // Override hash code
  @override
  int get hashCode => name.hashCode ^ location.hashCode;

  // ToString method for debugging
  @override
  String toString() {
    return 'MedicalCenter(name: $name, location: $location)';
  }
}