import 'package:dronify/src/Bottom_Nav/bottom_nav.dart';
import 'package:dronify/src/Scrollable_Splash/scrollable_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  Future<bool> _isUserLoggedIn() async {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Image.asset(
              'assets/drone.gif',
              height: 50,
              width: 50,
            ));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error checking login status.'));
          } else if (snapshot.data == true) {
            // User is logged in, go to HomeScreen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNav()),
              );
            });
          } else {
            // User is not logged in, go to SignInScreen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScrollableSplashScreen()),
              );
            });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
