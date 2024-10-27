import 'package:dronify_mngmt/models/customer_model.dart';

class OrderModel {
  final int? orderId;
  final CustomerModel? customer;
  final String? employeeId;
  final int? serviceId;
  final List<String>? images;
  final List<Map<String, dynamic>>? address;
  final double? squareMeters;
  final DateTime? reservationDate;
  final String? reservationTime;
  final double? totalPrice;
  final DateTime? orderDate;
  String? status;
  final double? orderRating;

  OrderModel({
    required this.orderId,
    required this.customer,
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
      orderId: json['order_id'] ?? 0,
      customer: json['app_user'] != null
          ? CustomerModel.fromJson(json['app_user'])
          : null,
      employeeId: json['employee_id'] ?? '',
      serviceId: json['service_id'] ?? 0,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((image) => image['image_url']))
          : [],
      address: json['address'] != null
          ? List<Map<String, dynamic>>.from(json['address'])
          : [],
      squareMeters: (json['square_meters'] ?? 0).toDouble(),
      reservationDate: json['reservation_date'] != null
          ? DateTime.parse(json['reservation_date'])
          : DateTime.now(),
      reservationTime: json['reservation_time'] ?? 'N/A',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      orderDate: json['order_date'] != null
          ? DateTime.parse(json['order_date'])
          : DateTime.now(),
      status: json['status'] ?? 'unknown',
      orderRating: (json['order_rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'customer': customer?.toJson(),
      'employee_id': employeeId,
      'service_id': serviceId,
      'images': images,
      'address': address,
      'square_meters': squareMeters,
      'reservation_date': reservationDate != null
          ? reservationDate!.toIso8601String().split('T').first
          : null,
      'reservation_time': reservationTime,
      'total_price': totalPrice,
      'order_date': orderDate != null
          ? orderDate!.toIso8601String().split('T').first
          : null,
      'status': status,
      'order_rating': orderRating,
    };
  }
}
