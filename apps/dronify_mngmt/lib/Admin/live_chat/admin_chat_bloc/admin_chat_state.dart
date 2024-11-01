part of 'admin_chat_bloc.dart';

@immutable
sealed class AdminChatState {}

class AdminChatInitial extends AdminChatState {}

class ChatsLoaded extends AdminChatState {
  final List<Map<String, dynamic>> chats;
  ChatsLoaded({required this.chats});
}

class NoChatsState extends AdminChatState {
}

class NewChatState extends AdminChatState {
  final String chatId;
  final String userId;

  NewChatState({required this.chatId, required this.userId});
}

class ChatError extends AdminChatState {
  final String message;
  ChatError({required this.message});
}
