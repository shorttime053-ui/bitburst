class Booking {
  final String id;
  final String userId;
  final String turfId;
  final String turfName;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String paymentStatus; // 'pending', 'paid', 'refunded'
  final String? paymentId;
  final Map<String, dynamic> bookingDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  Booking({
    required this.id,
    required this.userId,
    required this.turfId,
    required this.turfName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.paymentId,
    required this.bookingDetails,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      turfId: map['turfId'] ?? '',
      turfName: map['turfName'] ?? '',
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] ?? 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] ?? 0),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      paymentStatus: map['paymentStatus'] ?? 'pending',
      paymentId: map['paymentId'],
      bookingDetails: Map<String, dynamic>.from(map['bookingDetails'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'turfId': turfId,
      'turfName': turfName,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'totalPrice': totalPrice,
      'status': status,
      'paymentStatus': paymentStatus,
      'paymentId': paymentId,
      'bookingDetails': bookingDetails,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'notes': notes,
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? turfId,
    String? turfName,
    DateTime? startTime,
    DateTime? endTime,
    double? totalPrice,
    String? status,
    String? paymentStatus,
    String? paymentId,
    Map<String, dynamic>? bookingDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      turfId: turfId ?? this.turfId,
      turfName: turfName ?? this.turfName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentId: paymentId ?? this.paymentId,
      bookingDetails: bookingDetails ?? this.bookingDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }
}
