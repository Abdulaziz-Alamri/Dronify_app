import 'package:dronify_mngmt/Admin/Admin_Profile/profile_item.dart';
import 'package:dronify_mngmt/Admin/Admin_edit_profile/edit_profile.dart';
import 'package:dronify_mngmt/Auth/first_screen.dart';
import 'package:dronify_mngmt/repository/auth_repository.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String userName = 'John Doe';
    late String userEmaile = 'Jone_test@gmail.com';
    late String userPhone = '0966 5666789';
    late String userLocaition = 'Westpoint, JBR, room 4';
      final AuthRepository authRepository = AuthRepository();

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
                      const SizedBox(height: 20),
                      Text(
                        'WELCOME $userName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfile(),
                              ));
                        },
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async{
                            await authRepository.logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FirstScreen(),
                      ),
                      (route) => false,
                    );
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
