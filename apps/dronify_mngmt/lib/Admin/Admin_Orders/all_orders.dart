import 'package:dronify_mngmt/Admin/Admin_Orders/admin_available_card.dart';
import 'package:dronify_mngmt/Employee_Home/availble_orders.dart';
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';
import 'package:dronify_mngmt/Employee_Home/order_card.dart';
import 'package:dronify_mngmt/utils/order_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<dynamic> completeOrders = [];
  List<dynamic> incompleteOrders = [];
  List<dynamic> availableOrders = [];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    fetchOrders();
    super.initState();
  }

  Future<void> fetchOrders() async {
    try {
      final completeOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'complete');

      for (var object in completeOrdersResponse) {
        final order = OrderModel.fromJson(object);
        completeOrders.add(order);
      }

      final incompleteOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'confirmed');

       for (var object in incompleteOrdersResponse) {
        final order = OrderModel.fromJson(object);
        incompleteOrders.add(order);
      }

      final availableOrdersResponse = await supabase
          .from('orders')
          .select('*, app_user!inner(name, phone), service(name)')
          .eq('status', 'pending');

          for (var object in availableOrdersResponse) {
        final order = OrderModel.fromJson(object);
        availableOrders.add(order);
      }

      setState(() {});
    } catch (error) {
      print("Error fetching orders: $error");
    }
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
              centerTitle: true,
              title: const Text(
                'All Orders',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            backgroundColor: Colors.transparent,
            pinned: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xff072D6F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xff072D6F),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Container(
                          height: 7.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xff072D6F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
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
                              color: const Color(0xff072D6F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
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
                              color: const Color(0xff072D6F),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
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
                  const SizedBox(
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
                                  OrderCard(order: order),
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
                                  AdminAvailableCard(order: order),
                                  SizedBox(height: 15),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
