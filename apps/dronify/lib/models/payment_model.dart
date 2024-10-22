class PaymentModel {
  final int paymentId;
  final int orderId;
  final String customerId;
  final double amount;
  final DateTime paymentDate;

  PaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.customerId,
    required this.amount,
    required this.paymentDate,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'],
      orderId: json['order_id'],
      customerId: json['customer_id'],
      amount: json['amount'].toDouble(),
      paymentDate: DateTime.parse(json['payment_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'order_id': orderId,
      'customer_id': customerId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
    };
  }
}
