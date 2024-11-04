import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/src/Home/service_card.dart';
import 'package:dronify/src/Home/special_offer_card.dart';
import 'package:dronify/src/Home/welcome_card.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<String> fetchUserName() async {
    final dataLayer = locator<DataLayer>();

    final userId = dataLayer.supabase.auth.currentUser?.id;
    if (userId != null) {
      await dataLayer.getCustomer(userId);
    }
    return dataLayer.customer?.name ?? "User";
  }

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
                expandedHeight: 120.0,
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
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: FutureBuilder<String>(
                  future: fetchUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset(
                          'assets/drone.gif',
                          height: 50,
                          width: 50,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final userName = snapshot.data ?? "User";

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: WelcomeCard(
                              name: userName,
                            ),
                          ),
                          const SizedBox(height: 15),
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
                          Center(
                            child: const SpecialOfferCard(
                              imageUrl:
                                  'assets/Group_34606-removebg-preview.png',
                              title: 'Offer Cleaning Service',
                              description: 'Get 25%',
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
                          Center(
                            child: ServiceCard(
                              serviceId: 1,
                              imageUrl:
                                  'assets/Dasu-pulizia-facciata-con-drone-Milano 1.png',
                              title: 'Building Cleaning',
                              description:
                                  'Professional cleaning service for tall buildings using advanced drones.',
                              iconPath: 'assets/Vector (12).png',
                            ),
                          ),
                          SizedBox(
                            height: 240,
                            child: GridView(
                              // padding:
                              //     const EdgeInsets.symmetric(horizontal: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 40,
                                      mainAxisExtent: 180),
                              children: const [
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
                          SizedBox(height: 14.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
