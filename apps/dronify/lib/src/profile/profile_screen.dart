import 'package:dronify/repository/auth_repository.dart';
import 'package:dronify/src/Auth/sginin.dart';
import 'package:dronify/src/profile/Profile_Item.dart';
import 'package:dronify/src/wallet/wallet.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late String userName = 'John Doe';
    late String userEmaile = 'Jone_test@gmail.com';
    late String userPhone = '0966 5666789';
    late String userLocaition = 'Westpoint, JBR, room 4';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
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
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            pinned: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'WELCOME $userName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF072D6F), // Custom blue color
                        ),
                        child: const Text(
                          'Edit your profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ProfileItem(
                                icon: Icons.person,
                                text: userName,
                              ),
                              ProfileItem(
                                icon: Icons.email,
                                text: userEmaile,
                              ),
                              ProfileItem(
                                icon: Icons.phone,
                                text: userPhone,
                              ),
                              ProfileItem(
                                icon: Icons.location_on,
                                text: userLocaition,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.wallet),
                          title: const Text('Wallet'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Wallet()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await handleLogout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF072D6F),
                        ),
                        child: const Text('Log out',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//+
// ... previous code remains the same//+
Future<void> handleLogout(BuildContext context) async {
  try {
    await AuthRepository().logout(); // Create an instance and call logout

    // Navigate to Login Screen (or any other screen)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SignIn()), // Replace with your login screen widget
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout failed: ${e.toString()}')),
    );
  }
}
