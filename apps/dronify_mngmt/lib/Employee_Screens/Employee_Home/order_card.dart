import 'package:dronify_mngmt/Admin_Screens/Admin_Orders/admin_order_card.dart';
import 'package:dronify_mngmt/Admin_Screens/admin_datalayer/admin_data_layer.dart';
import 'package:dronify_mngmt/Employee_Screens/Employee_Order/order_screen.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/models/service_model.dart';
import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isAdmin;

  const OrderCard({super.key, required this.order, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    ServiceModel service =
        locator.get<AdminDataLayer>().allServices[order.serviceId! - 1];
    return GestureDetector(
      onTap: () {
        if (isAdmin || order.status == 'complete') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminOrderCard(order: order, service: service,),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderScreen(order: order),
            ),
          );
        }
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 130,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          service.description,
                          softWrap: true,
                          style:
                              const TextStyle(fontSize: 12, color: Color(0xffA4A4AA)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'Price: ${order.totalPrice} SAR',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff072D6F)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
