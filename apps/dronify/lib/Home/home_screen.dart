import 'package:dronify/Home/service_card.dart';
import 'package:dronify/Home/special_offer_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('assets/appbar1.png'))),
          ),
          Positioned(
            top: 80,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 175,
                    width: 345,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back User 👋',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff666C89)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'What you are looking for today?',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff172B4D)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff072D6F)),
                              borderRadius: BorderRadius.circular(360),
                              color: Color(0xff072D6F).withOpacity(0.28)),
                          child: Center(
                            child: Text(
                              'subscribe for Flexible Cleaning Schedules and Exclusive Pricing',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff072D6F)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Special Offers',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff172B4D)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 180,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SpecialOfferCard(
                            imageUrl: 'assets/drone.png',
                            title: 'Offer Cleaning Service',
                            description: 'Get 25%',
                          ),
                          SpecialOfferCard(
                            imageUrl: 'assets/drone.png',
                            title: 'Offer Cleaning Service',
                            description: 'Get 25%',
                          ),
                          SpecialOfferCard(
                            imageUrl: 'assets/drone.png',
                            title: 'Offer Cleaning Service',
                            description: 'Get 25%',
                          ),
                          SpecialOfferCard(
                            imageUrl: 'assets/drone.png',
                            title: 'Offer Cleaning Service',
                            description: 'Get 25%',
                          ),
                          SpecialOfferCard(
                            imageUrl: 'assets/drone.png',
                            title: 'Offer Cleaning Service',
                            description: 'Get 25%',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Services',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff172B4D)),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: GridView(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,childAspectRatio: 1,),
                      children: [
                        ServiceCard(
                          imageUrl: 'assets/clean.png',
                          title: 'Building Cleaning',
                        ),
                        ServiceCard(
                          imageUrl: 'assets/nano.jpg',
                          title: 'Nano Protection',
                        ),
                        ServiceCard(
                          imageUrl: 'assets/spot.jpg',
                          title: 'Spot Painting',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
