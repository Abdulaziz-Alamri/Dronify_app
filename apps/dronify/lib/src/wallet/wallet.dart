import 'dart:developer';

import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    final allServices =
                            locator.get<DataLayer>().allServices;
                        final orders =
                            locator.get<DataLayer>().allCustomerOrders;
    List<String> iconsPaths = [
      'assets/Vector (12).png',
      'assets/Group (1).png',
      'assets/Group (2).png'
    ];
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
                  Column(
                    children: [
                      ...List.generate(
                          locator.get<DataLayer>().allCustomerOrders.length,
                          (index) {
                        return ListTile(
                          leading: Image.asset(
                              iconsPaths[orders[index].serviceId! - 1]),
                          title: Text(allServices[orders[index].serviceId!-1].name),
                          subtitle: Text(DateFormat('d MMM yyyy')
                              .format(orders[index].reservationDate!)),
                          trailing: Text('-${orders[index].totalPrice} SAR'),
                        );
                      }),
                      IconButton(
                          onPressed: () {
                            log('$orders');
                          },
                          icon: Icon(Icons.print))
                      // ListTile(
                      //   leading: Image.asset('assets/Vector (12).png'),
                      //   title: Text('Building Cleaning'),
                      //   subtitle: Text('10 Oct 2024'),
                      //   trailing: Text('-100 SAR'),
                      // ),
                      // const Divider(),
                      // ListTile(
                      //   leading: Image.asset('assets/Group (1).png'),
                      //   title: const Text('Nano Protection'),
                      //   subtitle: const Text('9 Oct 2024'),
                      //   trailing: const Text('-50 SAR'),
                      // ),
                      // const Divider(),
                      // ListTile(
                      //   leading: Image.asset('assets/Group (2).png'),
                      //   title: Text('Spot Painting'),
                      //   subtitle: Text('9 Oct 2024'),
                      //   trailing: Text('-50 SAR'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
