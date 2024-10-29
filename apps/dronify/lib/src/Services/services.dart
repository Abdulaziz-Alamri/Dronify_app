import 'dart:io';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/src/Order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Services extends StatefulWidget {
  final ServiceModel service;

  const Services({
    super.key,
    required this.service,
    // required this.imageUrl,
    // required this.title,
    // required this.description,
    // required this.iconPath,
  });

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<XFile>? _images = [];
  final ImagePicker _picker = ImagePicker();
  String? _selectedDate;
  int windowCount = 1;
  bool showInfo = false;
  LatLng? currentLocation;
  LatLng? selectedLocation;
  bool isFromRiyadh = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController squareAreaController = TextEditingController();

  Future<void> _pickImage() async {
    if (_images!.length < 4) {
      final pickedFile = await _picker.pickMultiImage(limit: 4);
      setState(() {
        if (pickedFile != null) {
          _images = pickedFile;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can upload up to 4 images only.')),
      );
    }
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  String convertToDMS(double coordinate) {
    int degrees = coordinate.floor();
    double minutesWithDecimal = (coordinate - degrees) * 60;
    int minutes = minutesWithDecimal.floor();
    double seconds = (minutesWithDecimal - minutes) * 60;

    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.service.iconPath,
                      height: 18.sp,
                    ),
                    SizedBox(width: 1.h),
                    Text(
                      widget.service.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Color(0xffCDCDCD),
                  indent: 30,
                  endIndent: 30,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 360,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(widget.service.mainImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    widget.service.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xffA4A4AA),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xffCDCDCD),
                  indent: 30,
                  endIndent: 30,
                ),
                const SizedBox(height: 10),
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

                _images!.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_images![index].path),
                                    height: 100,
                                    width: 100,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _images!.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const Text('No images selected'),

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
                const SizedBox(height: 16),
                currentLocation != null
                    ? Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: currentLocation!,
                            maxZoom: 15.0,
                            onTap: (tapPosition, point) {
                              setState(() {
                                selectedLocation = point;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Selected Location: Latitude: ${convertToDMS(point.latitude)}, Longitude: ${convertToDMS(point.longitude)}'),
                                ),
                              );
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: const ['a', 'b', 'c'],
                            ),
                            if (selectedLocation != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: selectedLocation!,
                                    width: 80.0,
                                    height: 80.0,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
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
                    : const Text('No date selected'),
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
                        const SizedBox(width: 10),
                        Text(
                          '$windowCount',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                          controller: squareAreaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the square area';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffF5F5F5),
                            border: InputBorder.none,
                            hintText: 'Enter square area',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.help_outline),
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
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey[600]),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Checkbox(
                      value: isFromRiyadh,
                      onChanged: (value) {
                        setState(() {
                          isFromRiyadh = value!;
                        });
                      },
                    ),
                    Text(
                      'Are you from Riyadh?',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            isFromRiyadh &&
                            selectedLocation != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreen(
                                images: _images!,
                                order: OrderModel(
                                  orderId: 41221,
                                  customerId:
                                  "4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd",
                                  employeeId: '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd',
                                  serviceId: 1,
                                  images: _images != null
                                      ? _images!.map((e) => e.path).toList()
                                      : [],
                                  address: [
                                    convertToDMS(
                                        selectedLocation?.latitude ?? 0.0),
                                    convertToDMS(
                                        selectedLocation?.longitude ?? 0.0)
                                  ],
                                  squareMeters: double.tryParse(
                                          squareAreaController.text) ??
                                      0.0,
                                  reservationDate:
                                      DateTime.parse(_selectedDate!),
                                  reservationTime: DateTime.now(),
                                  totalPrice:
                                      double.parse(squareAreaController.text) *
                                          3,
                                  orderDate: DateTime.now(),
                                  status: "pending",
                                ),
                                service: widget.service,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please fill in all required fields')),
                          );
                        }
                      },
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
