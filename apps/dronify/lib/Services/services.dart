import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Services extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String iconPath;

  const Services({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.iconPath,
  });

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String? _selectedDate;
  int windowCount = 1;
  bool showInfo = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.iconPath,
                      height: 18.sp,
                    ),
                    SizedBox(
                      width: 1.h,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Color(0xffCDCDCD),
                  indent: 30,
                  endIndent: 30,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: 360,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Color(0xffA4A4AA),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xffCDCDCD),
                  indent: 30,
                  endIndent: 30,
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _pickImage,
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
                _image != null
                    ? Image.file(
                        File(_image!.path),
                        height: 100,
                      )
                    : Text('No image selected'),
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
                SizedBox(
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
                  onTap: _pickDate,
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
                _selectedDate != null
                    ? Text(
                        'Selected date: $_selectedDate',
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      )
                    : Text('No date selected'),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Number of Windows',
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
                            setState(() {
                              if (windowCount > 1) windowCount--;
                            });
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
                        SizedBox(width: 10),
                        Text(
                          '$windowCount',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              windowCount++;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xff072D6F),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Icon(
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
                      fillColor: Color(0xffF5F5F5),
                      border: InputBorder.none,
                      hintText: 'Enter square area',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.help_outline),
                        onPressed: () {
                          setState(() {
                            showInfo = !showInfo;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                if (showInfo)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      'Please enter the total square area of the windows.',
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ),
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
                        'Confirm Order',
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
