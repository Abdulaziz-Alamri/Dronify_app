import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/src/profile/Profile_Item.dart';
import 'package:dronify/src/profile/bloc/profile_bloc.dart';
import 'package:dronify/src/profile/bloc/profile_event.dart';
import 'package:dronify/src/profile/bloc/profile_state.dart';
import 'package:dronify/src/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dronify/models/customer_model.dart';
import 'package:dronify/src/Auth/sginin.dart';
import 'package:dronify/src/Wallet/wallet.dart';
import 'package:dronify/utils/setup.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(locator.get<DataLayer>())..add(LoadProfileEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(LoadProfileEvent());
              },
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Center(
                        child: Image.asset(
                      'assets/drone.gif',
                      height: 50,
                      width: 50,
                    ));
                  } else if (state is ProfileLoaded) {
                    return _buildProfileContent(context, state.customer);
                  } else if (state is ProfileError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Image.asset('assets/drone.gif'));
                  }
                },
              ),
            ),
          );
        },
      ),
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
                    const SizedBox(height: 20),
                    Text(
                      'WELCOME ${customer.name}',
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
                            builder: (context) => EditProfile(
                              name: customer.name,
                              phone: customer.phone,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF072D6F),
                      ),
                      child: const Text(
                        'Edit your profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileInfoCard(customer),
                    const SizedBox(height: 10),
                    _buildWalletButton(context),
                    const SizedBox(height: 30),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard(CustomerModel customer) {
    return Card(
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
            // const ProfileItem(
            //   icon: Icons.location_on,
            //   text: 'Location information here',
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletButton(BuildContext context) {
    return Card(
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
              builder: (context) => const Wallet(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        BlocProvider.of<ProfileBloc>(context).add(LogoutEvent());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF072D6F),
      ),
      child: const Text(
        'Log out',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
