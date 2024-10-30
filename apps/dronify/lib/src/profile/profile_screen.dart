import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/repository/auth_repository.dart';
import 'package:dronify/src/profile/Profile_Item.dart';
import 'package:dronify/src/profile/bloc/profile_bloc.dart';
import 'package:dronify/src/profile/bloc/profile_event.dart';
import 'package:dronify/src/profile/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dronify/models/customer_model.dart';
import 'package:dronify/src/Auth/sginin.dart';
import 'package:dronify/src/wallet/wallet.dart';
import 'package:dronify/utils/setup.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(locator.get<DataLayer>())
            ..add(LoadProfileEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                return _buildProfileContent(context, state.customer);
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text("Press button to load profile."));
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildProfileContent(BuildContext context, CustomerModel customer) {
    return CustomScrollView(
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
                      'WELCOME ${customer.name}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072D6F),
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
                              text: customer.name,
                            ),
                            ProfileItem(
                              icon: Icons.email,
                              text: customer.email,
                            ),
                            ProfileItem(
                              icon: Icons.phone,
                              text: customer.phone,
                            ),
                            ProfileItem(
                              icon: Icons.location_on,
                              text: 'Location information here',
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
                            MaterialPageRoute(
                              builder: (context) => Wallet(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(LogoutEvent());
                            
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
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
    );
  }
}
