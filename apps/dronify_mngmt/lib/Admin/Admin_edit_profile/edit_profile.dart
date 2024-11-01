import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: 
      gitbuildAppBar(context),
      body: Padding(
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
            buildTextField(
              hint: 'your name here',
            ),
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
            buildTextField(
              hint: 'your location here',
            ),
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
    );
  }

  /// Method to build the AppBar with a back button and title
  PreferredSizeWidget 
  gitbuildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/appbar1.png'), // Ensure the image is in assets
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          // Back Button and Title
          Positioned(
            left: 10,
            top: 40,
            child: Row(
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            // Custom hint text color and style
            color: Colors.grey, // Set the desired hint text color
            fontSize: 16, // Set the font size of the hint text
          ),
          filled: true,
          fillColor:
              const Color(0xffF5F5F7), // Background color for the TextField
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none, // No visible border
          ),
        ),
      ),
    );
  }
}
