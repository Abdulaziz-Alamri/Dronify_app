part of 'chat_message_bloc.dart';

@immutable
sealed class ChatMessageEvent {}

class LoadMessagesEvent extends ChatMessageEvent {}

class NewMessageReceivedEvent extends ChatMessageEvent {
  final Map<String, dynamic> newMessage;
  NewMessageReceivedEvent({required this.newMessage});
}

class SendMessageEvent extends ChatMessageEvent {
  final String message;
  final String chatId;
  final String userId;

  SendMessageEvent({
    required this.message,
    required this.chatId,
    required this.userId,
  });
}
