import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/src/Home/service_card.dart';
import 'package:dronify/src/Home/special_offer_card.dart';
import 'package:dronify/src/Home/welcome_card.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
    _fadeController.forward();
  }

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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: _slideAnimation,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: WelcomeCard(
                              name: userName,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Special Offers',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff172B4D)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: const SpecialOfferCard(
                              imageUrl:
                                  'assets/Group_34606-removebg-preview.png',
                              title: 'Offer Cleaning Service',
                              description: 'Get 25%',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Services',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff172B4D)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SlideTransition(
                          position: _slideAnimation,
                          child: Center(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 180,
                            child: GridView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 40,
                                      mainAxisExtent: 180),
                              children: [
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: const ServiceCard(
                                    serviceId: 2,
                                    imageUrl: 'assets/nano.jpg',
                                    title: 'Nano Protection',
                                    description:
                                        'Nano-coating protection for windows, shields from dirt and weather damage.',
                                    iconPath: 'assets/Group (1).png',
                                  ),
                                ),
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: const ServiceCard(
                                    serviceId: 3,
                                    imageUrl: 'assets/spot.jpg',
                                    title: 'Spot Painting',
                                    description:
                                        'Spot painting services for building exteriors.',
                                    iconPath: 'assets/Group (2).png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                      ],
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

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
