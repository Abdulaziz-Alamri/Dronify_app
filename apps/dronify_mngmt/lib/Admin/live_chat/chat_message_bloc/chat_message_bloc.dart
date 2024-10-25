import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';
import 'package:meta/meta.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  late final RealtimeChannel channel;
  final String chatId;

  ChatMessageBloc({required this.chatId}) : super(ChatMessageInitial()) {
    on<LoadMessagesEvent>(loadMessages);
    on<NewMessageReceivedEvent>(receiveNewMessage);
    on<SendMessageEvent>(sendMessage);
    initializeListener();
  }

  void initializeListener() {
    supabase
        .channel('public:chat_message')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_message',
          callback: (payload) async {
            final messageId = payload.newRecord['message_id'];

            // Fetch new message
            final response = await supabase
                .from('chat_message')
                .select('*')
                .eq('message_id', messageId)
                .neq('sender_id', 'a581cd5e-c67c-4522-a4bb-01b795c43387')
                .maybeSingle();

            if (response != null) {
              await Future.delayed(const Duration(seconds: 1));
              add(NewMessageReceivedEvent(newMessage: response));
            }
          },
        )
        .subscribe();
  }

  FutureOr<void> loadMessages(
      LoadMessagesEvent event, Emitter<ChatMessageState> emit) async {
    final response = await supabase
        .from('chat_message')
        .select('*')
        .eq('chat_id', chatId)
        .order('sent_at', ascending: false);

    final messages = response.map<types.TextMessage>((message) {
      return types.TextMessage(
        author: types.User(id: message['sender_id']),
        createdAt: DateTime.parse(message['sent_at']).millisecondsSinceEpoch,
        id: message['message_id'].toString(),
        text: message['message'],
      );
    }).toList();

    if (response.isNotEmpty) {
      emit(MessagesLoaded(messages: messages));
    } else {
      emit(ChatError(error: ''));
    }
  }

  FutureOr<void> sendMessage(
      SendMessageEvent event, Emitter<ChatMessageState> emit) async {
    if (state is MessagesLoaded) {
      final currentState = state as MessagesLoaded;

      final newMessage = types.TextMessage(
        author: types.User(id: event.userId),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'random_id_${Random().nextInt(1000)}',
        text: event.message,
      );

      emit(MessagesLoaded(messages: [newMessage, ...currentState.messages]));

      try {
        await supabase.from('chat_message').insert({
          'chat_id': event.chatId,
          'sender_id': event.userId,
          'message': event.message,
          'sent_at': DateTime.now().toString(),
        });
      } catch (error) {
        emit(ChatError(error: 'Failed to send message'));
      }
    }
  }

  FutureOr<void> receiveNewMessage(
      NewMessageReceivedEvent event, Emitter<ChatMessageState> emit) {
    if (state is MessagesLoaded) {
      final currentState = state as MessagesLoaded;

      final newMessage = types.TextMessage(
        author: types.User(id: event.newMessage['sender_id']),
        createdAt:
            DateTime.parse(event.newMessage['sent_at']).millisecondsSinceEpoch,
        id: event.newMessage['message_id'].toString(),
        text: event.newMessage['message'],
      );

      emit(MessagesLoaded(messages: [newMessage, ...currentState.messages]));
    }
  }

  @override
  Future<void> close() {
    channel.unsubscribe();
    return super.close();
  }
}
