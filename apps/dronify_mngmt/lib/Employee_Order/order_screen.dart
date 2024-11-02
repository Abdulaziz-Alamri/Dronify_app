import 'package:dronify_mngmt/Employee_Order/bloc/order_bloc.dart';
import 'package:dronify_mngmt/Employee_Order/bloc/order_event.dart';
import 'package:dronify_mngmt/Employee_Order/bloc/order_state.dart';
import 'package:dronify_mngmt/Employee_Order/confirm_screen.dart';
import 'package:dronify_mngmt/Employee_Order/custom_custmer_wedget.dart';
import 'package:dronify_mngmt/Employee_Order/custom_image_cards.dart';
import 'package:dronify_mngmt/Employee_Order/custom_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'dart:io';

class OrderScreen extends StatelessWidget {
  final int orderId;
  final TextEditingController descriptionController = TextEditingController();

  OrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc()..add(FetchOrderData(orderId)),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return Center(
                child: Image.asset('assets/custom_loading.gif'));
          } else if (state is OrderLoaded) {
            return Scaffold(
              backgroundColor: const Color(0xffF5F5F7),
              appBar: AppBar(
                backgroundColor: const Color(0xffF5F5F7),
                leading: BackButton(onPressed: () => Navigator.pop(context)),
                title: const Text(
                  'Order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Customer information
                    CustomCustmerWedget(
                      ordernumber: '${state.orderData.orderId}',
                      title: state.orderData.customer?.name ?? 'N/A',
                      subTitle: state.orderData.customer?.phone ?? 'N/A',
                    ),
                    const SizedBox(height: 15),

                    // Order information
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                                'Date: ${DateFormat('yyyy-MM-dd').format(state.orderData.reservationDate!)}',
                            subTitle:
                                'Time: ${state.orderData.reservationTime ?? 'N/A'}',
                          ),
                          const Divider(color: Color(0xffEDEDED), height: 20),
                          Text(
                            'Service: ${state.orderData.serviceId}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Status: ${state.orderData.status ?? 'N/A'}',
                            style: const TextStyle(color: Color(0xffA4A4AA)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
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
                            child: (state.orderData.images != null &&
                                    state.orderData.images!.isNotEmpty)
                                ? CustomImageCards(
                                    imageUrls: state.orderData.images!,
                                  )
                                : const Center(
                                    child: Text('No images available'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 210,
                      width: 345,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (state.location != null) {
                            MapsLauncher.launchCoordinates(
                              state.location!.latitude,
                              state.location!.longitude,
                            );
                          }
                        },
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: state.location ?? LatLng(0.0, 0.0),
                            maxZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            ),
                            if (state.location != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: state.location!,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        if (state.location != null) {
                                          MapsLauncher.launchCoordinates(
                                            state.location!.latitude,
                                            state.location!.longitude,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Description section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '* Description :',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
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
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: 'Enter description here...',
                                hintStyle: TextStyle(
                                    color: Colors.grey[500], fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: () => context.read<OrderBloc>().add(PickImages()),
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
                    const SizedBox(height: 15),
                    if (state.selectedImages.isNotEmpty)
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
                        child: (state.selectedImages.isNotEmpty)
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.selectedImages.length,
                                itemBuilder: (context, index) {
                                  final image = state.selectedImages[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: InteractiveViewer(
                                            child: Image.file(
                                              File(image.path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(image.path),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text('No images selected'),
                              ),
                      )
                    else
                      const Text('No images selected'),

                    const SizedBox(height: 15),

                    Center(
                      child: Container(
                        width: 335,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                            final description = descriptionController.text;
                            final imagesAsFiles = state.selectedImages
                                .map((xFile) => File(xFile.path))
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmScreen(
                                  images: imagesAsFiles,
                                  description: description,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Add description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
