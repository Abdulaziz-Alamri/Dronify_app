import 'package:dronify/utils/setup.dart';
import 'package:dronify/layer/data_layer.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  EditProfile({
    Key? key,
    required String name,
    required String phone,
  })  : nameController = TextEditingController(text: name),
        phoneController = TextEditingController(text: phone),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
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
            buildTextField(controller: nameController),
            const SizedBox(height: 16),
            const Text(
              'Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            buildTextField(controller: phoneController),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dataLayer = locator.get<DataLayer>();
          await dataLayer.updateCustomerProfile(
            name: nameController.text,
            phone: phoneController.text,
          );
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFF072D6F),
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Edit Profile"),
      backgroundColor: const Color(0xFF072D6F),
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffF5F5F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
