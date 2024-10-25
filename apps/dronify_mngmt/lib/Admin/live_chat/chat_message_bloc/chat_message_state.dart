part of 'chat_message_bloc.dart';

@immutable
sealed class ChatMessageState {}

final class ChatMessageInitial extends ChatMessageState {}

class MessagesLoaded extends ChatMessageState {
  final List<types.Message> messages;
  MessagesLoaded({required this.messages});
}

class ChatError extends ChatMessageState {
  final String error;
  ChatError({required this.error});
}
