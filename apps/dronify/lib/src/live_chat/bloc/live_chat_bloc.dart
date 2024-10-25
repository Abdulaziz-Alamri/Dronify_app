import 'dart:async';

import 'package:dronify/utils/db_operations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'live_chat_event.dart';
import 'live_chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final RealtimeChannel channel;
  ChatBloc(String chatId) : super(ChatInitial()) {
    on<LoadMessagesEvent>(loadMessages);
    on<SendMessageEvent>(sendMessage);
    on<NewMessageReceivedEvent>(receiveNewMessage);
    initializeListener(chatId);
  }

  void initializeListener(String chatId) async {
    channel = supabase
        .channel('public:chat_message')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_message',
          callback: (payload) async {
            if (payload.newRecord.isNotEmpty) {
              final messageId = payload.newRecord['message_id'];

              // Fetch new message
              final response = await supabase
                  .from('chat_message')
                  .select('*')
                  .eq('message_id', messageId)
                  .eq('sender_id', 'a581cd5e-c67c-4522-a4bb-01b795c43387')
                  .maybeSingle();

              if (response != null) {
                final newMessage = types.TextMessage(
                  author: types.User(id: response['sender_id']),
                  createdAt: DateTime.parse(response['sent_at'])
                      .millisecondsSinceEpoch,
                  id: response['message_id'].toString(),
                  text: response['message'],
                );

                await Future.delayed(const Duration(seconds: 1));

                add(NewMessageReceivedEvent(message: newMessage.text, messageId: newMessage.id));
              }
            }
          },
        )
        .subscribe();
  }

  Future<void> loadMessages(
      LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      final response = await supabase
          .from('chat_message')
          .select('*, app_user(*)')
          .eq('chat_id', event.chatId)
          .order('sent_at', ascending: false);

      final messages = response.map<types.TextMessage>((message) {
        return types.TextMessage(
          author: types.User(id: message['app_user']['user_id']),
          createdAt: DateTime.parse(message['sent_at']).millisecondsSinceEpoch,
          id: message['message_id'].toString(),
          text: message['message'],
        );
      }).toList();

      emit(ChatLoaded(messages));
    } catch (error) {
      emit(ChatError('Failed to load messages'));
    }
  }

  Future<void> sendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      final newMessage = types.TextMessage(
        author: types.User(id: event.userId),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'random_id_${Random().nextInt(1000)}',
        text: event.message,
      );

      emit(ChatLoaded([newMessage, ...currentState.messages]));

      try {
        await supabase.from('chat_message').insert({
          'chat_id': event.chatId,
          'sender_id': event.userId,
          'message': event.message,
          'sent_at': DateTime.now().toIso8601String(),
        });
      } catch (error) {
        emit(ChatError('Failed to send message'));
      }
    }
  }


  FutureOr<void> receiveNewMessage(
    NewMessageReceivedEvent event, Emitter<ChatState> emit) {
  if (state is ChatLoaded) {
    final currentState = state as ChatLoaded;

    final newMessage = types.TextMessage(
      author: types.User(id: 'a581cd5e-c67c-4522-a4bb-01b795c43387'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: event.messageId,
      text: event.message,
    );

    emit(ChatLoaded([newMessage, ...currentState.messages]));
  }
}


  Future<void> close() {
    channel.unsubscribe();
    return super.close();
  }

  // void _onLoadMessages(
  //     LoadMessagesEvent event, Emitter<ChatState> emit) {
  //   emit(ChatLoading());

  //   var initialMessage = types.TextMessage(
  //     author: const types.User(id: 'user2'),
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     id: 'random_id_1',
  //     text: 'Hello! How can I assist you?',
  //   );

  //   emit(ChatLoaded([initialMessage]));
  // }

  // void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) {
  //   if (state is ChatLoaded) {
  //     final currentState = state as ChatLoaded;

  //     final newMessage = types.TextMessage(
  //       author: types.User(id: 'user1'),
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: 'random_id_${Random().nextInt(1000)}',
  //       text: event.message,
  //     );

  //     emit(ChatLoaded([newMessage, ...currentState.messages]));
  //   }
  // }
}
