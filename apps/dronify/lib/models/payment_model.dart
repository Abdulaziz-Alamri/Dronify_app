class PaymentModel {
  int? paymentId;
  final int orderId;
  final String userId; 
  final double amount;
  DateTime? paymentDate;

  PaymentModel({
    this.paymentId,
    required this.orderId,
    required this.userId, 
    required this.amount,
    DateTime? paymentDate,
  }) : paymentDate = paymentDate ?? DateTime.now();

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'],
      orderId: json['order_id'],
      userId: json['user_id'], // تغيير إلى userId
      amount: json['amount'].toDouble(),
      paymentDate: DateTime.parse(json['payment_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'order_id': orderId,
      'user_id': userId, // تغيير إلى userId
      'amount': amount,
      'payment_date': paymentDate?.toIso8601String(),
    };
  }
}
