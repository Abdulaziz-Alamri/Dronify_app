// مو شرط ترجع لي النتيجه بسرعه اهم شي ترجع لي الكود كامل وابغاك تبني بلوك على كود import 'package:dronify_mngmt/Employee_Order/confirm_screen.dart';
// import 'package:dronify_mngmt/Employee_Order/custom_custmer_wedget.dart';
// import 'package:dronify_mngmt/Employee_Order/custom_image_cards.dart';
// import 'package:dronify_mngmt/Employee_Order/custom_order_card.dart';
// import 'package:dronify_mngmt/models/order_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:sizer/sizer.dart';
// import 'dart:io';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:maps_launcher/maps_launcher.dart';

// class OrderScreen extends StatefulWidget {
//   final int orderId;

//   const OrderScreen({super.key, required this.orderId});

//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   final supabase = Supabase.instance.client;
//   final ImagePicker _picker = ImagePicker();
//   OrderModel? orderData;
//   LatLng? currentLocation;
//   List<XFile> _selectedImages = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchOrderData();
//     _getCurrentLocation();
//   }

//   double? _dmsToDecimal(String dms) {
//     final dmsPattern =
//         RegExp(r"""(-?\d+)[°]\s*(\d+)[']\s*(\d+\.?\d*)["]\s*([NSEW]?)""");
//     final match = dmsPattern.firstMatch(dms);

//     if (match != null) {
//       final degrees = double.parse(match.group(1)!);
//       final minutes = double.parse(match.group(2)!);
//       final seconds = double.parse(match.group(3)!);
//       final direction = match.group(4);

//       double decimal = degrees + (minutes / 60) + (seconds / 3600);

//       if (direction == 'S' || direction == 'W') {
//         decimal = -decimal;
//       }

//       return decimal;
//     } else {
//       print('Invalid DMS format: $dms');
//       return null;
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw 'Location services are disabled.';
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw 'Location permissions are denied';
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw 'Location permissions are permanently denied.';
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         currentLocation = LatLng(position.latitude, position.longitude);
//       });
//     } catch (e) {
//       print("Error getting current location: $e");
//       setState(() {
//         currentLocation = LatLng(0.0, 0.0);
//       });
//     }
//   }

//   Future<void> _fetchOrderData() async {
//     try {
//       final response = await supabase
//           .from('orders')
//           .select(
//               '*, app_user!inner(name, phone), service(name, description), address(latitude, longitude), images(image_url)')
//           .eq('order_id', widget.orderId)
//           .maybeSingle();

//       print('Response from Supabase: $response');

//       if (response != null && response.isNotEmpty) {
//         setState(() {
//           orderData = OrderModel.fromJson(response);
//         });
//       } else {
//         print('No data found for the provided order ID.');
//       }
//     } catch (error) {
//       print('Error fetching order data: $error');
//     }
//   }

//   Future<void> _pickImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         _selectedImages = pickedFiles.take(4).toList();
//       });
//     }
//   }

//   void zoom(BuildContext context, File imageFile) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: InteractiveViewer(
//             child: Image.file(
//               imageFile,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xffF5F5F7),
//         leading: BackButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Order',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: orderData == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   CustomCustmerWedget(
//                     ordernumber: '${orderData!.orderId}',
//                     title: orderData!.customer?.name ?? 'N/A',
//                     subTitle: orderData!.customer?.phone ?? 'N/A',
//                   ),
//                   const SizedBox(height: 15),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 16),
//                     width: 345,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 3,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomOrderCard(
//                           imageUrl: 'assets/drone.png',
//                           title:
//                               'Date: ${DateFormat('yyyy-MM-dd').format(orderData!.reservationDate!)}',
//                           subTitle: 'Time: ${orderData!.reservationTime}',
//                         ),
//                         const Divider(color: Color(0xffEDEDED), height: 20),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               orderData!.serviceId.toString(),
//                               style: const TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               orderData!.status ?? 'N/A',
//                               style: const TextStyle(color: Color(0xffA4A4AA)),
//                             ),
//                           ],
//                         ),
//                         const Divider(color: Color(0xffEDEDED), height: 20),
//                         Row(
//                           children: [
//                             Image.asset('assets/drone_icon.png'),
//                             const SizedBox(width: 10),
//                             const Text(
//                               'Cleaning',
//                               style: TextStyle(
//                                   fontSize: 12, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             const Icon(Icons.track_changes_outlined,
//                                 color: Color(0xff072D6F)),
//                             const SizedBox(width: 10),
//                             Text(
//                               orderData != null &&
//                                       orderData!.address != null &&
//                                       orderData!.address!.isNotEmpty
//                                   ? '${orderData!.address![0]['latitude'] ?? 'N/A'}, ${orderData!.address![0]['longitude'] ?? 'N/A'}'
//                                   : 'Address not found',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             const Icon(Icons.access_time_filled_outlined,
//                                 color: Color(0xff072D6F)),
//                             const SizedBox(width: 10),
//                             Text(
//                               orderData!.reservationTime ?? 'N/A',
//                               style: const TextStyle(
//                                   fontSize: 12, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                           height: 100,
//                           width: 345,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 3,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: (orderData!.images != null &&
//                                   orderData!.images!.isNotEmpty)
//                               ? CustomImageCards(
//                                   imageUrls: orderData!.images!,
//                                 )
//                               : const Center(
//                                   child: Text('No images available')),
//                         ),
//                         const SizedBox(height: 15),
//                         Container(
//                           height: 210,
//                           width: 345,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: currentLocation != null
//                               ? GestureDetector(
//                                   onTap: () {
//                                     if (currentLocation != null) {
//                                       MapsLauncher.launchCoordinates(
//                                         currentLocation!.latitude,
//                                         currentLocation!.longitude,
//                                       );
//                                     }
//                                   },
//                                   child: FlutterMap(
//                                     options: MapOptions(
//                                       initialCenter: LatLng(
//                                         _dmsToDecimal(orderData?.address?[0]
//                                                 ['latitude']) ??
//                                             currentLocation?.latitude ??
//                                             0.0,
//                                         _dmsToDecimal(orderData?.address?[0]
//                                                 ['longitude']) ??
//                                             currentLocation?.longitude ??
//                                             0.0,
//                                       ),
//                                       maxZoom: 15.0,
//                                     ),
//                                     children: [
//                                       TileLayer(
//                                         urlTemplate:
//                                             "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
//                                       ),
//                                       MarkerLayer(
//                                         markers: [
//                                           if (orderData?.address != null &&
//                                               orderData!.address!.isNotEmpty)
//                                             Marker(
//                                               width: 80.0,
//                                               height: 80.0,
//                                               point: LatLng(
//                                                 _dmsToDecimal(
//                                                         orderData!.address![0]
//                                                             ['latitude']) ??
//                                                     currentLocation!.latitude,
//                                                 _dmsToDecimal(
//                                                         orderData!.address![0]
//                                                             ['longitude']) ??
//                                                     currentLocation!.longitude,
//                                               ),
//                                               child: IconButton(
//                                                 onPressed: () {
//                                                   if (currentLocation != null) {
//                                                     final latitude =
//                                                         _dmsToDecimal(orderData
//                                                                     ?.address?[0]
//                                                                 ['latitude']) ??
//                                                             currentLocation!
//                                                                 .latitude;
//                                                     final longitude = _dmsToDecimal(
//                                                             orderData?.address?[
//                                                                     0][
//                                                                 'longitude']) ??
//                                                         currentLocation!
//                                                             .longitude;

//                                                     MapsLauncher
//                                                         .launchCoordinates(
//                                                             latitude,
//                                                             longitude);
//                                                   }
//                                                 },
//                                                 icon: Icon(
//                                                   Icons.location_on,
//                                                   color: Colors.red,
//                                                   size: 40,
//                                                 ),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : const Center(
//                                   child: Text("Location not available"),
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         '* Description :',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         maxLines: 4,
//                         decoration: InputDecoration(
//                           hintText: 'Enter description here...',
//                           hintStyle: TextStyle(
//                             color: Colors.grey[500],
//                             fontSize: 14,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.all(12),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   GestureDetector(
//                     onTap: _pickImages,
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         Icons.add,
//                         size: 30,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   _selectedImages.isNotEmpty
//                       ? Container(
//                           height: 100,
//                           width: 345,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 3,
//                                 offset: const Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: _selectedImages.map((image) {
//                               return GestureDetector(
//                                 onTap: () => zoom(context, File(image.path)),
//                                 child: SizedBox(
//                                   height: 67,
//                                   width: 70,
//                                   child: Card(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     elevation: 5,
//                                     shadowColor: Colors.black,
//                                     color: Colors.white,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.file(
//                                         File(image.path),
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                           return Icon(Icons.broken_image);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         )
//                       : const Text('No images selected'),
//                   const SizedBox(height: 15),
//                   Center(
//                     child: Container(
//                       width: 335,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color(0xFF072D6F),
//                             Color(0xFF0A3F9A),
//                             Color(0xFF0A43A4),
//                             Color(0xFF0D56D5),
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ConfirmScreen(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: const Text(
//                           'Add description',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                 ],
//               ),
//             ),
//     );
//   }
// }