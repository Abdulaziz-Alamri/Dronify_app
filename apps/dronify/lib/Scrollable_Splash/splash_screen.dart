import 'package:dronify/Scrollable_Splash/splash_content.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: currentIndex != 2
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF072D6F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ),
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: [
              SplashContent(
                imagePath: 'assets/drone.png',
                title: 'Clean your Building',
                description:
                    'Lorem ipsum is a placeholder text commonly used to demonstrate the visual.',
              ),
              SplashContent(
                imagePath: 'assets/drone.png',
                title: 'Nano Protection',
                description: 'Keep your building protected for the long term.',
              ),
              SplashContent(
                imagePath: 'assets/drone.png',
                title: 'Drone Services',
                description:
                    'Automated and safe solutions for facade cleaning.',
              ),
            ],
          ),
          Positioned(
            bottom: 330,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Color(0xFF072D6F)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 50,
            right: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                backgroundColor: Color(0xFF072D6F),
              ),
              onPressed: () {
                if (currentIndex < 2) {
                  pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {}
              },
              child: Text(
                currentIndex == 2 ? 'Get Started' : 'Next',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
