class OrderModel {
  final int? orderId;
  final String? customerId;
  final String? employeeId;
  final int? serviceId;
  final List<String>? images;
  final List<String>? address;
  final double? squareMeters;
  final DateTime? reservationDate;
  final DateTime? reservationTime;
  final double? totalPrice;
  final DateTime? orderDate;
  String? status;
  final double? orderRating;

  OrderModel({
    required this.orderId,
    required this.customerId,
    this.employeeId,
    required this.serviceId,
    required this.images,
    required this.address,
    required this.squareMeters,
    required this.reservationDate,
    required this.reservationTime,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    this.orderRating,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      customerId: json['user_id'],
      employeeId: json['employee_id'] ?? null,
      serviceId: json['service_id'],
      images: List<String>.from(json['images']),
      address: json['address'],
      squareMeters: json['square_meters'].toDouble(),
      reservationDate: DateTime.parse(json['reservation_date']),
      reservationTime: DateTime.parse(json['reservation_time']),
      totalPrice: json['total_price'].toDouble(),
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      orderRating: json['order_rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'customer_id': customerId,
      'employee_id': employeeId,
      'service_id': serviceId,
      'images': images,
      'address': address,
      'square_meters': squareMeters,
      'reservation_date': reservationDate!.toIso8601String(),
      'reservation_time': reservationTime!.toIso8601String(),
      'total_price': totalPrice,
      'order_date': orderDate!.toIso8601String(),
      'status': status,
      'order_rating': orderRating,
    };
  }
}
