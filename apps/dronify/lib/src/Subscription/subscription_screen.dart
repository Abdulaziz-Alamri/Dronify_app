import 'package:dronify/src/Subscription/custom_sub_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    XFile? image;
    final ImagePicker picker = ImagePicker();
    String? selectedDate;
    int windowCount = 1;
    bool showInfo = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F7),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'subscription',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                const CustomSubCard(
                    duration: 3,
                    description:
                        'Includes 6 visits (two visits each month) to maintain your building’s appearance.',
                    price: 1500),
                const CustomSubCard(
                    duration: 6,
                    description:
                        'Includes 12 visits (two visits each month), perfect for ongoing cleanliness with fewer subscriptions.',
                    price: 1500),
                const CustomSubCard(
                    duration: 9,
                    description:
                        'Includes 18 visits (two visits each month), an excellent choice for those needing consistent maintenance at a great value.',
                    price: 1500),
                SizedBox(
                  height: 2.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upload images',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  // onTap: _pickImage,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // _image != null
                //     ?
                //     Image.file(
                //         File(_image!.path),
                //         height: 100,
                //       )
                //     : Text('No image selected'),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your location',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 210,
                  width: 345,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(
                    'assets/map.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select date',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  // onTap: _pickDate,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 30,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // _selectedDate != null
                //     ? Text(
                //         'Selected date: $_selectedDate',
                //         style: TextStyle(fontSize: 16.sp, color: Colors.black),
                //       )
                //     : Text('No date selected'),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Number of Units',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            // setState(() {
                            //   if (windowCount > 1) windowCount--;
                            // });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTapDown: (_) {
                            // setState(() {
                            //   windowCount++;
                            // });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff072D6F),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Square area',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: InputBorder.none,
                      hintText: 'Enter square area',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: () {
                          // setState(() {
                          //   showInfo = !showInfo;
                          // });
                        },
                      ),
                    ),
                  ),
                ),
                // if (showInfo)
                //   Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 5.w),
                //     child: Text(
                //       'Please enter the total square area of the windows.',
                //       style:
                //           TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                //     ),
                //   ),
                SizedBox(height: 4.h),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF072D6F),
                          Color(0xFF0A3F9A),
                          Color(0xFF0A43A4),
                          Color(0xFF0D56D5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
