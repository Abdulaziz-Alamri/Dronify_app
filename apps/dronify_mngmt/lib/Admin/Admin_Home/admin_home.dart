import 'package:dronify_mngmt/Admin/Admin_Home/custom_stat_card.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/employees_barchart.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/orders_stats.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/profit_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  Future<double> fetchUserCount() async {
    final response = await Supabase.instance.client.rpc('count_users');
    if (response == null) {
      throw Exception('Failed to load user count');
    }
    return (response as int).toDouble();
  }

  Future<double> fetchOrderCount() async {
    final response = await Supabase.instance.client.rpc('count_orders');
    if (response == null) {
      throw Exception('Failed to load order count');
    }
    return (response as int).toDouble();
  }

  Future<double> fetchTotalProfits() async {
    final response = await Supabase.instance.client.rpc('total_profits');
    if (response == null) {
      throw Exception('Failed to load total profits');
    }
    return (response as num).toDouble();
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
                'Welcome Back Admin 👋',
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
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FutureBuilder<double>(
                            future: fetchUserCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                debugPrint(
                                    'Error fetching user count: ${snapshot.error}');
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CustomStatCard(
                                  title: 'Users',
                                  value: '${snapshot.data?.toInt()}',
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: FutureBuilder<double>(
                            future: fetchOrderCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                debugPrint(
                                    'Error fetching order count: ${snapshot.error}');
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CustomStatCard(
                                  title: 'Orders',
                                  value: '${snapshot.data?.toInt()}',
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: FutureBuilder<double>(
                            future: fetchTotalProfits(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                debugPrint(
                                    'Error fetching total profits: ${snapshot.error}');
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CustomStatCard(
                                  title: 'Profits',
                                  value: '${snapshot.data?.toStringAsFixed(0)}',
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const ProfitChart(),
                    const SizedBox(height: 10),
                    const EmployeesBarchart(),
                    const SizedBox(height: 10),
                    const OrdersStats(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
