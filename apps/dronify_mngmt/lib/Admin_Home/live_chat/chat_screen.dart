import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    ...List.generate(5, (index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 75,
                            width: 345,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Chat Number/ID',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff072D6F)),
                                ),
                                Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF072D6F),
                                        Color(0xFF0A3F9A),
                                        Color(0xFF0A43A4),
                                        Color(0xFF0D56D5),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Chat',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
