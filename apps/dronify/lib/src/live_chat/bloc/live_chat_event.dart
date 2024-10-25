import 'package:flutter_chat_ui/flutter_chat_ui.dart' as types;

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  final String userId;
  final String chatId;

  SendMessageEvent({required this.message, required this.userId, required this.chatId});
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  LoadMessagesEvent({required this.chatId});
}

class NewMessageReceivedEvent extends ChatEvent {
  final String message;
  final String messageId;

  NewMessageReceivedEvent({required this.message, required this.messageId});
}