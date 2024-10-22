class ChatModel {
  final int chatId;
  final String customerId;
  final String adminId;
  final DateTime startTime;

  ChatModel({
    required this.chatId,
    required this.customerId,
    required this.adminId,
    required this.startTime,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chat_id'],
      customerId: json['customer_id'],
      adminId: json['admin_id'],
      startTime: DateTime.parse(json['start_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'customer_id': customerId,
      'admin_id': adminId,
      'start_time': startTime.toIso8601String(),
    };
  }
}
