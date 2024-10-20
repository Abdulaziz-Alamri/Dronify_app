import 'package:dronify_mngmt/order_card.dart';
import 'package:flutter/material.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> with SingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  TabBar(
                    controller: tabController,
                    tabs: [
                    Tab(
                      text: 'Complete',
                    ),
                    Tab(
                      text: 'Incomplete',
                    )
                  ]),
                   SizedBox(
                    height: MediaQuery.of(context).size.height,
                     child: TabBarView(
                          controller: tabController,
                          children: [ 
                          OrderCard(),
                          OrderCard(),
                          ]),
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
