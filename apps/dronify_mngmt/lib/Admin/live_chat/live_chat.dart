import 'package:dronify_mngmt/Admin/live_chat/chat_message_bloc/chat_message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class LiveChat extends StatelessWidget {
  final String chatId;
  const LiveChat({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatMessageBloc(chatId: chatId)..add(LoadMessagesEvent()),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: BlocConsumer<ChatMessageBloc, ChatMessageState>(
          listener: (context, state) {
            if (state is ChatError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is MessagesLoaded) {
              return buildChat(context, state.messages);
            } else if (state is ChatError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Center(
                child: Image.asset(
              'assets/drone.gif',
              height: 50,
              width: 50,
            ));
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
              'Admin Live Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChat(BuildContext context, List<types.Message> messages) {
    final adminUserId = '0cf2efe9-94b7-482b-9c85-de2122e4a675';

    return Chat(
      messages: messages,
      onSendPressed: (partialText) {
        context.read<ChatMessageBloc>().add(SendMessageEvent(
              message: partialText.text,
              chatId: chatId,
              userId: adminUserId,
            ));
      },
      user: types.User(id: adminUserId),
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
