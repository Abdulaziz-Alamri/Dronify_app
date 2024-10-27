class ChatMessageModel {
  final int messageId;
  final int chatId;
  final String senderId;
  final String message;
  final DateTime timestamp;

  ChatMessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      messageId: json['message_id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'chat_id': chatId,
      'sender_id': senderId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
