import 'dart:developer';

import 'package:dronify/src/Auth/sginin.dart';
import 'package:dronify/src/Scrollable_Splash/bloc/scrollsplash_bloc.dart';
import 'package:dronify/src/Scrollable_Splash/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollableSplashScreen extends StatefulWidget {
  const ScrollableSplashScreen({super.key});

  @override
  State<ScrollableSplashScreen> createState() => _ScrollableSplashScreenState();
}

class _ScrollableSplashScreenState extends State<ScrollableSplashScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScrollsplashBloc(),
      child: Builder(builder: (context) {
        final bloc = context.read<ScrollsplashBloc>();
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                BlocBuilder<ScrollsplashBloc, ScrollsplashState>(
                  builder: (context, state) {
                    return PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        bloc.add(ChangeIndexEvent(currentIndex: index));
                      },
                      children: [
                        const SplashContent(
                          imagePath: 'assets/splash_drone.png',
                          title: 'Clean your Building',
                          description:
                              'Experience effortless facade cleaning with our state-of-the-art drone technology, ensuring your building looks pristine without the hassle.',
                        ),
                        const SplashContent(
                          imagePath: 'assets/splash_drone2.png',
                          title: 'Nano Protection',
                          description:
                              'Safeguard your surfaces with our advanced nano protection treatments. Our drones apply cutting-edge solutions that repel dirt and grime, keeping your building looking newer for longer.',
                        ),
                        const SplashContent(
                          imagePath: 'assets/drone13.png',
                          title: 'Drone Services',
                          description:
                              'Harness the power of drones for a variety of maintenance solutions, combining efficiency with exceptional results. Whether it\'s cleaning or protective coatings, we offer a seamless, eco-friendly approach to building maintenance.',
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: currentIndex != 2
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF072D6F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Container(),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return BlocBuilder<ScrollsplashBloc,
                              ScrollsplashState>(
                            builder: (context, state) {
                              return Container(
                                height: 10,
                                width: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: bloc.currentIndex == index
                                      ? const Color(0xFF072D6F)
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 50,
                  right: 50,
                  child: BlocBuilder<ScrollsplashBloc, ScrollsplashState>(
                    builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            backgroundColor: const Color(0xFF072D6F),
                          ),
                          onPressed: () {
                            if (bloc.currentIndex < 2) {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()),
                              );
                            }
                          },
                          child: Text(
                            bloc.currentIndex == 2 ? 'Get Started' : 'Next',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
