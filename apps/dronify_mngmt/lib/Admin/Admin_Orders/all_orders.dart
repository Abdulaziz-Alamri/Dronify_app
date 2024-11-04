import 'package:dronify_mngmt/Admin/Admin_Orders/admin_available_card.dart';
import 'package:dronify_mngmt/Admin/Admin_Orders/admin_orders_cubit/admin_orders_cubit.dart';
import 'package:dronify_mngmt/Admin/Admin_Orders/empty_tab_image.dart';
import 'package:dronify_mngmt/Employee_Home/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminOrdersCubit()..loadOrders(),
      child: Builder(builder: (context) {
        final cubit = context.read<AdminOrdersCubit>();
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
                        builder: (context, state) {
                          if (state is OrdersLoadedState) {
                            return SizedBox(
                              height: 660,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  // Complete Orders Tab
                                  if(cubit.completeOrders.isEmpty)
                                  Image.asset('name'),
                                  SingleChildScrollView(
                                    child: cubit.completeOrders.isNotEmpty
                                        ? Column(
                                            children: cubit.completeOrders
                                                .map((order) {
                                              return Column(
                                                children: [
                                                  OrderCard(
                                                      order: order,
                                                      isAdmin: true),
                                                  const SizedBox(height: 15),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : const EmptyTabImage(
                                            imagePath:
                                                'assets/empty_orders.png',
                                            message: 'No incomplete orders.'),
                                  ),
                                  // Incomplete Orders Tab
                                  SingleChildScrollView(
                                    child: cubit.incompleteOrders.isNotEmpty
                                        ? Column(
                                            children: cubit.incompleteOrders
                                                .map((order) {
                                              return Column(
                                                children: [
                                                  OrderCard(
                                                      order: order,
                                                      isAdmin: true),
                                                  const SizedBox(height: 15),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : const EmptyTabImage(
                                            imagePath:
                                                'assets/empty_orders.png',
                                            message: 'No incomplete orders.'),
                                  ),
                                  // Available Orders Tab
                                  SingleChildScrollView(
                                    child: cubit.availableOrders.isNotEmpty
                                        ? Column(
                                            children: cubit.availableOrders
                                                .map((order) {
                                              return Column(
                                                children: [
                                                  AdminAvailableCard(
                                                      order: order,
                                                      cubit: cubit),
                                                  const SizedBox(height: 15),
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : const EmptyTabImage(
                                            imagePath:
                                                'assets/empty_orders.png',
                                            message: 'No incomplete orders.'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Center(
                            child: Image.asset(
                              'assets/drone.gif',
                              height: 50,
                              width: 50,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
