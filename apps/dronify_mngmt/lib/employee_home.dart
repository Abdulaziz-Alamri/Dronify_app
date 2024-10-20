import 'package:flutter/material.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    // TabController tabController = TabController(length: 2, vsync: vsync);
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
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
              title: Text(
                'Welcome Back Emp 👋',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            backgroundColor: Colors.transparent,
            pinned: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CircleAvatar(),
                  Text('data'),
                  Text('data'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Complete Orders'),
                  // LinearProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTabController(
                    length: 2,
                    child: TabBar(tabs: [
                      Tab(
                        text: 'Complete',
                      ),
                      Tab(
                        text: 'Incomplete',
                      )
                    ]),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        height: 117,
                        width: 311,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
