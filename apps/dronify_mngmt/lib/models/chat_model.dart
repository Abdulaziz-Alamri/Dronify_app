class OrderModel {
  final int? orderId;
  final String? customerId;
  final String? employeeId;
  final int? serviceId;
  final List<Map<String, dynamic>>? address;
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
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id'] ?? ''),
      customerId: json['user_id'],
      employeeId: json['employee_id'],
      serviceId: json['service_id'] is int ? json['service_id'] : int.tryParse(json['service_id'] ?? ''),
      address: json['address'] != null ? List<Map<String, dynamic>>.from(json['address']) : null,
      squareMeters: (json['square_meters'] as num?)?.toDouble(),
      reservationDate: DateTime.tryParse(json['reservation_date']),
      reservationTime: DateTime.tryParse(json['reservation_time']),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      orderDate: DateTime.tryParse(json['order_date']),
      status: json['status'],
      orderRating: (json['order_rating'] as num?)?.toDouble(),
    );
  }
}
