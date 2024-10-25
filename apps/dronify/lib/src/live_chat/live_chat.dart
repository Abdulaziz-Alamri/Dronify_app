import 'package:dronify/utils/db_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'bloc/live_chat_bloc.dart';
import 'bloc/live_chat_event.dart';
import 'bloc/live_chat_state.dart' as custom_state;

class ChatScreen extends StatelessWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(chatId)..add(LoadMessagesEvent(chatId: chatId)),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: BlocConsumer<ChatBloc, custom_state.ChatState>(
          listener: (context, state) {
            if (state is custom_state.ChatError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
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

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Stack(
        children: [
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
          Positioned(
            left: 10,
            top: 10,
            child: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 70,
            right: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await endChat(chatId: chatId);
                Navigator.pop(context);
              },
              child: const Text(
                'End Chat',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChat(BuildContext context, List<types.Message> messages) {
    final currentUserId = '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd';

    return Chat(
      messages: messages,
      onSendPressed: (partialText) {
        context.read<ChatBloc>().add(SendMessageEvent(
              message: partialText.text,
              chatId: chatId,
              userId: currentUserId,
            ));
      },
      user: types.User(id: currentUserId),
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
