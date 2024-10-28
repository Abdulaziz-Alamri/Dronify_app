import 'package:dronify_mngmt/Employee_Order/custom_custmer_wedget.dart';
import 'package:dronify_mngmt/Employee_Order/custom_image_cards.dart';
import 'package:dronify_mngmt/Employee_Order/custom_order_card.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:dronify_mngmt/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

class AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  final ServiceModel service;

  const AdminOrderCard({super.key, required this.order, required this.service});

  double? _dmsToDecimal(String dms) {
    final dmsPattern =
        RegExp(r'''(\d+)[°\s]*(\d+)\'\s*(\d+\.?\d*)"?\s*([NSEW]?)''');
    final match = dmsPattern.firstMatch(dms);

    if (match == null) {
      print("Invalid DMS format: $dms");
      return null;
    }

    final degrees = double.tryParse(match.group(1)!) ?? 0.0;
    final minutes = double.tryParse(match.group(2)!) ?? 0.0;
    final seconds = double.tryParse(match.group(3)!) ?? 0.0;
    final direction = match.group(4);

    // حساب الدرجة العشرية
    double decimal = degrees + (minutes / 60) + (seconds / 3600);

    // تحويل الاتجاه إلى سالب إذا كان الاتجاه جنوب أو غرب
    if (direction == 'S' || direction == 'W') {
      decimal = -decimal;
    }

    return decimal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F7),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Order',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CustomCustmerWedget(
                ordernumber: '${order.orderId}',
                title: order.customer?.name ?? 'N/A',
                subTitle: order.customer?.phone ?? 'N/A',
              ),
              const SizedBox(height: 15),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomOrderCard(
                      imageUrl: 'assets/drone.png',
                      title:
                          'Date: ${DateFormat('yyyy-MM-dd').format(order.reservationDate!)}',
                      subTitle: 'Time: ${order.reservationTime}',
                    ),
                    const Divider(color: Color(0xffEDEDED), height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: ${order.totalPrice} SAR',
                          style: const TextStyle(color: Color(0xffA4A4AA)),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xffEDEDED), height: 20),
                    Row(
                      children: [
                        Image.asset('assets/drone_icon.png'),
                        const SizedBox(width: 10),
                        const Text(
                          'Cleaning',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.track_changes_outlined,
                            color: Color(0xff072D6F)),
                        const SizedBox(width: 10),
                        Text(
                          '${order.address![0]['latitude'] ?? 'N/A'}, ${order.address![0]['longitude'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_outlined,
                            color: Color(0xff072D6F)),
                        const SizedBox(width: 10),
                        Text(
                          order.reservationTime ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      height: 100,
                      width: 345,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: CustomImageCards(
                        imageUrls: order.images!,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                        height: 210,
                        width: 345,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                                _dmsToDecimal(order.address?[0]['latitude'])!,
                                _dmsToDecimal(order.address?[0]['longitude'])!),
                            maxZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: LatLng(
                                      _dmsToDecimal(
                                          order.address?[0]['latitude'])!,
                                      _dmsToDecimal(
                                          order.address?[0]['longitude'])!),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              if (order.status == 'completed')
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '* Description :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter description here...',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              // GestureDetector(
              //   onTap: _pickImage,
              //   child: Container(
              //     width: 60,
              //     height: 60,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Icon(
              //       Icons.add,
              //       size: 30,
              //       color: Colors.grey[700],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 2.h),
              // _image != null
              //     ? Image.file(
              //         File(_image!.path),
              //         height: 100,
              //       )
              //     : const Text('No image selected'),
              // const SizedBox(height: 15),
              // Center(
              //   child: Container(
              //     width: 335,
              //     height: 48,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       gradient: const LinearGradient(
              //         colors: [
              //           Color(0xFF072D6F),
              //           Color(0xFF0A3F9A),
              //           Color(0xFF0A43A4),
              //           Color(0xFF0D56D5),
              //         ],
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //       ),
              //     ),
              //     child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const ConfirmScreen(),
              //           ),
              //         );
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.transparent,
              //         shadowColor: Colors.transparent,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //       ),
              //       child: const Text(
              //         'Add description',
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
