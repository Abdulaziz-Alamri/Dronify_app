import 'package:dronify_mngmt/Employee_Home/availble_orders.dart';
import 'package:dronify_mngmt/Employee_Home/order_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<dynamic> completeOrders = [];
  List<dynamic> incompleteOrders = [];
  List<dynamic> availableOrders = [];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final completeOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'complete');
      completeOrders = completeOrdersResponse as List<dynamic>;

      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'confirmed');
      incompleteOrders = incompleteOrdersResponse as List<dynamic>;

      final availableOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'pending');
      availableOrders = availableOrdersResponse as List<dynamic>;

      setState(() {});
    } catch (error) {
      print("Error fetching orders: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff072D6F),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/pfp_emp.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Employee Name',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: E-123324',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
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
              centerTitle: true,
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
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff152381),
                    backgroundImage: AssetImage('assets/pfp_emp.png'),
                  ),
                  Text(
                    'Employee Name',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff072D6F)),
                  ),
                  Text(
                    'ID: E-123324',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Complete Orders',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff072D6F)),
                      ),
                    ),
                  ),
                  Container(
                    height: 2.5.h,
                    width: 81.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.4))),
                    child: LinearProgressIndicator(
                      minHeight: 2.5.h,
                      value: 0.75,
                      borderRadius: BorderRadius.circular(25),
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff072D6F)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: Color(0xff072D6F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xff072D6F),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Container(
                          height: 7.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xff072D6F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Complete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 7.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xff072D6F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Incomplete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 7.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Color(0xff072D6F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        // Complete Orders Tab
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: completeOrders.map((order) {
                              return Column(
                                children: [
                                  OrderCard(order: order),
                                  SizedBox(height: 15),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        // Incomplete Orders Tab
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: incompleteOrders.map((order) {
                              return Column(
                                children: [
                                  OrderCard(order: order), // Pass order data
                                  SizedBox(height: 15),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        // Available Orders Tab
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: availableOrders.map((order) {
                              return Column(
                                children: [
                                  AvailbleOrders(order: order),
                                  SizedBox(height: 15),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
