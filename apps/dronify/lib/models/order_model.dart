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
    DateTime parsedReservationDate = DateTime.parse(json['reservation_date']);
    DateTime parsedReservationTime = DateTime.parse("${json['reservation_date']}T${json['reservation_time']}");

    return OrderModel(
      orderId: json['order_id'],
      customerId: json['user_id'],
      employeeId: json['employee_id'],
      serviceId: json['service_id'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      address: json['address'] != null ? List<String>.from(json['address']) : [],
      squareMeters: (json['square_meters'] as num).toDouble(),
      reservationDate: parsedReservationDate,
      reservationTime: parsedReservationTime,
      totalPrice: (json['total_price'] as num).toDouble(),
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      orderRating: json['order_rating'] != null ? (json['order_rating'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': customerId,
      'employee_id': employeeId,
      'service_id': serviceId,
      'images': images,
      'address': address,
      'square_meters': squareMeters,
      'reservation_date': reservationDate?.toIso8601String(),
      'reservation_time': reservationTime != null ? reservationTime!.toIso8601String().split('T').last : null,
      'total_price': totalPrice,
      'order_date': orderDate?.toIso8601String(),
      'status': status,
      'order_rating': orderRating,
    };
  }
}
