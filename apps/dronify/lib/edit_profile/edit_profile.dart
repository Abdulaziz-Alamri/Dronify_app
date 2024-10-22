import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context), // Add SliverAppBar here
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'User Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(hint: 'Your name here'),
                  const SizedBox(height: 16),
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(
                    hint: '0966 5xx xxx xxx',
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(hint: 'Your location here'),
                  const SizedBox(height: 16),
                  const Text(
                    'Date of Birth',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(hint: 'dd/mm/yy', readOnly: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SliverAppBar with background image and back button
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/appbar1.png'), // Ensure the image exists
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
    );
  }

  /// Reusable TextField widget with shadow
  Widget buildTextField({required String hint, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color for the TextField
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Shadow color
            blurRadius: 6, // Shadow blur radius
            offset: Offset(0, 2), // Offset for shadow position
          ),
        ],
      ),
      child: TextField(
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey, // Custom hint text color
            fontSize: 16,
          ),
          filled: true,
          fillColor: const Color(0xffF5F5F7), // Background color for TextField
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
