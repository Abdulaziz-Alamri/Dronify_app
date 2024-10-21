import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final types.User _user = const types.User(id: 'user1');

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    types.TextMessage message = types.TextMessage(
      author: const types.User(id: 'user2'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'random_id_1',
      text: 'Hello! How can I assist you?',
    );

    setState(() {
      _messages = [message];
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'random_id_${Random().nextInt(1000)}',
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150), // Adjust the height
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/appbar1.png'), // Ensure the image is in assets folder
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          primaryColor:
              Color.fromARGB(255, 63, 78, 90), // Chat bubble color
          backgroundColor: Colors.white, // Background color
          sentMessageBodyTextStyle: TextStyle(
            color: Colors.white, // Text color for sent messages
            fontSize: 16,
          ),
          receivedMessageBodyTextStyle: TextStyle(
            color: Colors.black, // Text color for received messages
            fontSize: 16,
          ),
          inputTextColor: Colors.black, // Input field text color
        ),
      ),
    );
  }
}
