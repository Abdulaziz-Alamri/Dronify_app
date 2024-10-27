class ReceiptModel {
  final int receiptId;
  final int orderId;
  final int paymentId;
  final String receiptUrl;
  final DateTime issuedDate;

  ReceiptModel({
    required this.receiptId,
    required this.orderId,
    required this.paymentId,
    required this.receiptUrl,
    required this.issuedDate,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      receiptId: json['receipt_id'],
      orderId: json['order_id'],
      paymentId: json['payment_id'],
      receiptUrl: json['receipt_url'],
      issuedDate: DateTime.parse(json['issued_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receipt_id': receiptId,
      'order_id': orderId,
      'payment_id': paymentId,
      'receipt_url': receiptUrl,
      'issued_date': issuedDate.toIso8601String(),
    };
  }
}
