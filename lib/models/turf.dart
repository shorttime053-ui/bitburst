class Turf {
  final String id;
  final String name;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final List<String> images;
  final List<String> sports;
  final List<TimeSlot> availableSlots;
  final double rating;
  final int reviewCount;
  final String ownerId;
  final Map<String, dynamic> amenities;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Turf({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.images,
    required this.sports,
    required this.availableSlots,
    required this.rating,
    required this.reviewCount,
    required this.ownerId,
    required this.amenities,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Turf.fromMap(Map<String, dynamic> map) {
    return Turf(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      pricePerHour: (map['pricePerHour'] ?? 0.0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      sports: List<String>.from(map['sports'] ?? []),
      availableSlots: (map['availableSlots'] as List<dynamic>?)
          ?.map((slot) => TimeSlot.fromMap(slot))
          .toList() ?? [],
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      ownerId: map['ownerId'] ?? '',
      amenities: Map<String, dynamic>.from(map['amenities'] ?? {}),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'pricePerHour': pricePerHour,
      'images': images,
      'sports': sports,
      'availableSlots': availableSlots.map((slot) => slot.toMap()).toList(),
      'rating': rating,
      'reviewCount': reviewCount,
      'ownerId': ownerId,
      'amenities': amenities,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Turf copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    double? pricePerHour,
    List<String>? images,
    List<String>? sports,
    List<TimeSlot>? availableSlots,
    double? rating,
    int? reviewCount,
    String? ownerId,
    Map<String, dynamic>? amenities,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Turf(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      images: images ?? this.images,
      sports: sports ?? this.sports,
      availableSlots: availableSlots ?? this.availableSlots,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      ownerId: ownerId ?? this.ownerId,
      amenities: amenities ?? this.amenities,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? bookedBy;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.bookedBy,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      id: map['id'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] ?? 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] ?? 0),
      isAvailable: map['isAvailable'] ?? true,
      bookedBy: map['bookedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'isAvailable': isAvailable,
      'bookedBy': bookedBy,
    };
  }

  TimeSlot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    String? bookedBy,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      bookedBy: bookedBy ?? this.bookedBy,
    );
  }
}
