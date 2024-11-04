import 'dart:async';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'admin_chat_event.dart';
part 'admin_chat_state.dart';

class AdminChatBloc extends Bloc<AdminChatEvent, AdminChatState> {
  late final RealtimeChannel channel;

  AdminChatBloc() : super(AdminChatInitial()) {
    on<LoadChatsEvent>(loadChats);
    on<NewChatEvent>(receiveNewChat);

    initializeListener();
  }

  void initializeListener() {
    channel = supabase
        .channel('public:live_chat')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'live_chat',
          callback: (payload) async {
            if (payload.newRecord.isNotEmpty) {
              add(NewChatEvent(
                newChat: payload.newRecord,
              ));
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'live_chat',
          callback: (payload) async {
            if (payload.newRecord.isNotEmpty) {
              final status = payload.newRecord['status'];
              if (status == 'ended') {
                add(LoadChatsEvent());
              }
            }
          },
        )
        .subscribe();
  }

  FutureOr<void> loadChats(
      LoadChatsEvent event, Emitter<AdminChatState> emit) async {
    final response = await supabase
        .from('live_chat')
        .select('*')
        .eq('status', 'started')
        .order('created_at', ascending: false);
    if (response.isNotEmpty) {
      emit(ChatsLoaded(chats: response));
    } else {
      emit(NoChatsState());
    }
  }

FutureOr<void> receiveNewChat(
    NewChatEvent event, Emitter<AdminChatState> emit) async {
  if (state is ChatsLoaded) {
    final updatedChats = List<Map<String, dynamic>>.from((state as ChatsLoaded).chats);
    
    updatedChats.insert(0, event.newChat);
    
    emit(ChatsLoaded(chats: updatedChats));
  }
}

  @override
  Future<void> close() {
    channel.unsubscribe();
    return super.close();
  }
}
