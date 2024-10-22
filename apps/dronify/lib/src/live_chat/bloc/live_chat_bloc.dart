import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:math';
import 'live_chat_event.dart';
import 'live_chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onLoadMessages(
      LoadMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatLoading());

    var initialMessage = types.TextMessage(
      author: const types.User(id: 'user2'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'random_id_1',
      text: 'Hello! How can I assist you?',
    );

    emit(ChatLoaded([initialMessage]));
  }

  void _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      final newMessage = types.TextMessage(
        author: types.User(id: 'user1'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'random_id_${Random().nextInt(1000)}',
        text: event.message,
      );
      
      emit(ChatLoaded([newMessage, ...currentState.messages]));
    }
  }
}
