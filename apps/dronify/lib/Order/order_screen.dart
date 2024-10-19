import 'package:dronify/Order/custom_image_cards.dart';
import 'package:dronify/Order/custom_order_card.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F5F7),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 75,
                  width: 345,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: CustomOrderCard(
                      imageUrl: 'assets/drone12.png',
                      title: 'Customer Name',
                      subTitle: '0512341234')),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 380,
              width: 345,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomOrderCard(
                      imageUrl: 'assets/drone.png',
                      title:
                          'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      subTitle:
                          'Time: ${DateTime.now().hour}:${DateTime.now().minute}'),
                  Divider(
                    color: Color(0xffEDEDED),
                    height: 20,
                  ),
                  Text(
                    'Price: 350 SAR',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Building Cleaning',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'A competitive type of auction in which participants compete for a contract, offering each time a price lower than that of competitors',
                        style: TextStyle(color: Color(0xffA4A4AA)),
                      ),
                    ],
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset('assets/drone_icon.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Cleaning',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.track_changes_outlined,
                        color: Color(0xff072D6F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Westpoint, JBR, room 4',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_outlined,
                        color: Color(0xff072D6F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '19:00',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Color(0xff072D6F),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Cash - payment method',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: 100,
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CustomImageCards()),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 210,
              width: 345,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/map.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                width: 335,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF072D6F),
                      Color(0xFF0A3F9A),
                      Color(0xFF0A43A4),
                      Color(0xFF0D56D5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
