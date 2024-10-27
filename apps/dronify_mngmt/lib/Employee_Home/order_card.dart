import 'package:dronify_mngmt/Employee_Order/order_screen.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic>? order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(orderId: order!['order_id']),
          ),
        );
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      child: Image.asset(
                        'assets/clean.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order?['service']?['name'] ?? 'Service Name',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          order?['service']?['description'] ??
                              'Service Description',
                          softWrap: true,
                          style:
                              TextStyle(fontSize: 12, color: Color(0xffA4A4AA)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'Price: ${order?['total_price'] ?? 'N/A'} SAR',
                style: TextStyle(
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
