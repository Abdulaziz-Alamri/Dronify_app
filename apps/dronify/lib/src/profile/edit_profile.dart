import 'package:dronify/utils/setup.dart';
import 'package:dronify/layer/data_layer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  EditProfile({
    super.key,
    required String name,
    required String phone,
  })  : nameController = TextEditingController(text: name),
        phoneController = TextEditingController(text: phone);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 80.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
                  ),
                  backgroundColor: Colors.transparent,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
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
                ),
              ],
            ),
            Positioned(
              left: 3.w,
              top: 7.h,
              child: BackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
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
