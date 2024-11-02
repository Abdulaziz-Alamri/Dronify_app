import 'package:dronify_mngmt/Admin/Admin_Orders/admin_order_card.dart';
import 'package:dronify_mngmt/Admin/Admin_Orders/admin_orders_cubit/admin_orders_cubit.dart';
import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/models/service_model.dart';
import 'package:dronify_mngmt/utils/db_operations.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';

class AdminAvailableCard extends StatelessWidget {
  final OrderModel order;
  final AdminOrdersCubit cubit;

  const AdminAvailableCard(
      {super.key, required this.order, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final ServiceModel service =
        locator.get<AdminDataLayer>().allServices[order.serviceId! - 1];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminOrderCard(
                    order: order,
                    service: locator
                        .get<AdminDataLayer>()
                        .allServices[order.serviceId! - 1])));
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 150,
          width: 400,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black,
                      color: Colors.white,
                      child: Image.network(
                        service.mainImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${service.name}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${service.description}',
                          softWrap: true,
                          style:
                              TextStyle(fontSize: 12, color: Color(0xffA4A4AA)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Cancelation'),
                              content: const Text(
                                  'Do you want to Cancel the order?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    cancelOrder(order: order);
                                    cubit.loadOrders();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text(
                'Price: ${order.totalPrice} SAR',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff072D6F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
