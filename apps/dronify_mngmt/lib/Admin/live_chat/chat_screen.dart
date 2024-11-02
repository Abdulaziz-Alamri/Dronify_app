import 'package:dronify_mngmt/Admin/live_chat/admin_chat_bloc/admin_chat_bloc.dart';
import 'package:dronify_mngmt/Admin/live_chat/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AdminChatBloc()..add(LoadChatsEvent()),
        child: Builder(builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: BackButton(
                  color: Colors.white,
                ),
                expandedHeight: 80.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
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
                  title: const Text(
                    'Chat Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
                backgroundColor: Colors.white,
                pinned: false,
              ),
              BlocBuilder<AdminChatBloc, AdminChatState>(
                builder: (context, state) {
                  if (state is ChatsLoaded) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final chat = state.chats[index];
                          if (chat['status'] == 'started') {
                            return ChatItem(chatId: chat['chat_id'].toString());
                          }
                          return SizedBox.shrink();
                        },
                        childCount: state.chats.length,
                      ),
                    );
                  } else if (state is NoChatsState) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text('No Chats Yet!!')),
                    );
                  } else if (state is ChatError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    );
                  }
                  return SliverToBoxAdapter(
                    child:
                        Center(child: Image.asset('assets/custom_loading.gif')),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
