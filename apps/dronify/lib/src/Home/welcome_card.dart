import 'package:dronify/src/Subscription/subscription_screen.dart';
import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  final String name;
  WelcomeCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: 345,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back $name 👋',
            style: const TextStyle(fontSize: 14, color: Color(0xff666C89)),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'What you are looking for today?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff072D6F),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionScreen(),
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff072D6F)),
                borderRadius: BorderRadius.circular(360),
                color: const Color(0xff072D6F),
              ),
              child: const Center(
                child: Text(
                  'subscribe now',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
