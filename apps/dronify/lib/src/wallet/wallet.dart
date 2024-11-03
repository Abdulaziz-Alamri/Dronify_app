import 'dart:developer';

import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/src/wallet/wallet_cubit/wallet_cubit.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    final allServices = locator.get<DataLayer>().allServices;
    List<String> iconsPaths = [
      'assets/Vector (12).png',
      'assets/Group (1).png',
      'assets/Group (2).png'
    ];
    return BlocProvider(
      create: (context) => WalletCubit()..loadOrders(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
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
                    child: Align(
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                pinned: true,
                title: Text(
                  'Wallet',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: const Text(
                          'Your balance is: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'PREVIOUS ORDERS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SingleChildScrollView(
                        child: BlocBuilder<WalletCubit, WalletState>(
                          builder: (context, state) {
                            if (state is WalletLoading) {
                              return Center(
                                child: Image.asset('assets/custom_loading.gif'),
                              );
                            } else if (state is WalletLoaded) {
                              return Column(
                                children:
                                    List.generate(state.orders.length, (index) {
                                  return ListTile(
                                    leading: Image.asset(iconsPaths[
                                        state.orders[index].serviceId! - 1]),
                                    title: Text(allServices[
                                            state.orders[index].serviceId! - 1]
                                        .name),
                                    subtitle: Text(DateFormat('d MMM yyyy')
                                        .format(state
                                            .orders[index].reservationDate!)),
                                    trailing: Text(
                                        '-${state.orders[index].totalPrice} SAR'),
                                  );
                                }),
                              );
                            } else if (state is WalletError) {
                              return Center(
                                child: Text(state.message),
                              );
                            } else {
                              return const Center(
                                child: Text('No orders found'),
                              );
                            }
                          },
                        ),
                      ),
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
