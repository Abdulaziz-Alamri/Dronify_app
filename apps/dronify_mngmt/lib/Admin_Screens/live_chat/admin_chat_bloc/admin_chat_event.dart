part of 'admin_chat_bloc.dart';

@immutable
sealed class AdminChatEvent {}

class LoadChatsEvent extends AdminChatEvent {}

class NewChatEvent extends AdminChatEvent {
 final Map<String, dynamic> newChat;
  NewChatEvent({required this.newChat});
}