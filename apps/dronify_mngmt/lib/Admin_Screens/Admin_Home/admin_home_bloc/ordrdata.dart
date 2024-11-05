class OrderData {
  final int orderId;
  final int serviceId;
  final double squareMeters;
  final double totalPrice;

  OrderData({
    required this.orderId,
    required this.serviceId,
    required this.squareMeters,
    required this.totalPrice,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['order_id'],
      serviceId: json['service_id'],
      squareMeters: json['square_meters'],
      totalPrice: json['total_price'],
    );
  }
}
