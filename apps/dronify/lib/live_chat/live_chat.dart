import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'bloc/live_chat_bloc.dart';
import 'bloc/live_chat_event.dart';
import 'bloc/live_chat_state.dart' as custom_state;

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc()..add(LoadMessagesEvent()),
      child: Scaffold(
        appBar: buildAppBar(),
        body: BlocBuilder<ChatBloc, custom_state.ChatState>(
          builder: (context, state) {
            if (state is custom_state.ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is custom_state.ChatLoaded) {
              return buildChat(context, state.messages);
            } else if (state is custom_state.ChatError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('No messages yet.'));
            }
          },
        ),
      ),
    );
  }

  /// Method to build the AppBar with custom styling.
  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/appbar1.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  /// Method to build the Chat UI with messages.
  Widget buildChat(BuildContext context, List<types.Message> messages) {
    return Chat(
      messages: messages,
      onSendPressed: (partialText) {
        context.read<ChatBloc>().add(SendMessageEvent(partialText.text));
      },
      user: const types.User(id: 'user1'),
      theme: const DefaultChatTheme(
        primaryColor: Color.fromARGB(255, 102, 196, 255),
        backgroundColor: Colors.white,
        sentMessageBodyTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        receivedMessageBodyTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        inputTextColor: Colors.black,
      ),
    );
  }
}
