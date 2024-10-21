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
        appBar: buildAppBar(context), // Pass context here
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

  /// Method to build the AppBar with a Back Button and custom styling.
  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Stack(
        children: [
          // Background image
          Container(
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
          // Title overlay
          const Positioned(
            left: 70,
            bottom: 30,
            child: Text(
              'Live Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Back Button
          Positioned(
            left: 10,
            top: 10,
            child: BackButton(
              color: Colors.white, // Back button color
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
          ),
        ],
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
        inputTextColor: Color.fromARGB(255, 138, 135, 135),
      ),
    );
  }
}
