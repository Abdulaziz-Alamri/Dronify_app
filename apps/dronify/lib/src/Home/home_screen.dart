import 'package:dronify/src/Home/service_card.dart';
import 'package:dronify/src/Home/special_offer_card.dart';
import 'package:dronify/src/Home/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 140.0,
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
                      child: Image.asset(
                        'assets/Group 34611.png',
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                pinned: false,
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                        alignment: Alignment.topCenter,
                        child: WelcomeCard()),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Special Offers',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff172B4D)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 150,
                        child: ListView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          children: const [
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
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Services',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff172B4D)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        height: 500,
                        child: GridView(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 40,
                                  mainAxisExtent: 220),
                          children: const [
                            ServiceCard(
                              serviceId: 1,
                              imageUrl: 'assets/clean.png',
                              title: 'Building Cleaning',
                              description:
                                  'Professional cleaning service for tall buildings using advanced drones.',
                              iconPath: 'assets/Vector (12).png',
                            ),
                            ServiceCard(
                              serviceId: 2,
                              imageUrl: 'assets/nano.jpg',
                              title: 'Nano Protection',
                              description:
                                  'Nano-coating protection for windows, shields from dirt and weather damage.',
                              iconPath: 'assets/Group (1).png',
                            ),
                            ServiceCard(
                              serviceId: 3,
                              imageUrl: 'assets/spot.jpg',
                              title: 'Spot Painting',
                              description:
                                  'Spot painting services for building exteriors.',
                              iconPath: 'assets/Group (2).png',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
