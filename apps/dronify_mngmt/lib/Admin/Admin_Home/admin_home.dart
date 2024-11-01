import 'package:dronify_mngmt/Admin/Admin_Home/custom_stat_card.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/employees_barchart.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/orders_stats.dart';
import 'package:dronify_mngmt/Admin/Admin_Home/profit_chart.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> profits = [0, 500, 1500, 1000, 4000];

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomStatCard(title: 'Users', value: '10K'),
                      CustomStatCard(title: 'Orders', value: '10K'),
                      CustomStatCard(title: 'Profits', value: '10K'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ProfitChart(profits: profits),
                  const SizedBox(
                    height: 10,
                  ),
                  EmployeesBarchart(),
                  const SizedBox(
                    height: 10,
                  ),
                  OrdersStats(),
                  SizedBox(
                    height: 120,
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
