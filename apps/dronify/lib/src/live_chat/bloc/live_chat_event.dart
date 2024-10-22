abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent(this.message);
}

class LoadMessagesEvent extends ChatEvent {}
