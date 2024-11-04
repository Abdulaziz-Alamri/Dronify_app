import 'dart:io';
import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/models/service_model.dart';
import 'package:dronify/src/Order/order_screen.dart';
import 'package:dronify/src/Services/services_bloc/services_bloc.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_map/flutter_map.dart';


class Services extends StatefulWidget {
  final ServiceModel service;
  final String iconpath;
  const Services({
    super.key,
    required this.service,
    required this.iconpath,
  });

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController squareAreaController = TextEditingController();
  late final int? orderId;

  @override
  void initState() {
    super.initState();
    initializeOrderId();
  }

  initializeOrderId() async {
    orderId = await getOrderId();
  }

  String convertToDMS(double coordinate) {
    int degrees = coordinate.floor();
    double minutesWithDecimal = (coordinate - degrees) * 60;
    int minutes = minutesWithDecimal.floor();
    double seconds = (minutesWithDecimal - minutes) * 60;

    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesBloc()..add(FetchLocationEvent()),
      child: Builder(builder: (context) {
        final bloc = context.read<ServicesBloc>();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButton(
                            onPressed: () => Navigator.pop(context),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                widget.iconpath,
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
                          const Icon(
                            Icons.circle,
                            color: Colors.transparent,
                          )
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
                        onTap: () {
                          bloc.add(PickImageEvent());
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff0A7995), Color(0xff73DDFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      BlocBuilder<ServicesBloc, ServicesState>(
                        buildWhen: (previous, current) =>
                            current is ImagesUpdatedState,
                        builder: (context, state) {
                          if (state is ImagesUpdatedState &&
                              state.images.isNotEmpty) {
                            return SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          File(state.images[index].path),
                                          height: 100,
                                          width: 100,
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              bloc.add(RemovedImageEvent(
                                                  image: bloc.images[index]));
                                            },
                                            child: const Icon(
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
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 2.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your Location',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<ServicesBloc, ServicesState>(
                        buildWhen: (previous, current) =>
                            current is LocationFetchedState &&
                            previous is! PinnedLocationState,
                        builder: (context, state) {
                          if (state is LocationFetchedState) {
                            return Container(
                              height: 210,
                              width: 345,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 2, color: const Color(0xff73DDFF)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: state.location,
                                    maxZoom: 15.0,
                                    onTap: (tapPosition, point) {
                                      bloc.add(PinLocationEvent(
                                          tapPosition: tapPosition,
                                          point: point));
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
                                    if (bloc.selectedLocation != null)
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: bloc.selectedLocation!,
                                            width: 80.0,
                                            height: 80.0,
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Image.asset(
                            'assets/drone.gif',
                            height: 50,
                            width: 50,
                          );
                        },
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
                        onTap: () {
                          bloc.add(PickDateEvent(context: context));
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff0A7995), Color(0xff73DDFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.calendarDays,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      BlocBuilder<ServicesBloc, ServicesState>(
                        buildWhen: (previous, current) =>
                            current is DateSelectedState,
                        builder: (context, state) {
                          if (state is DateSelectedState) {
                            return Text(
                              'Selected date: ${bloc.selectedDate}',
                              style:
                                  TextStyle(fontSize: 16.sp, color: Colors.black),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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
                                  if (bloc.unitCount > 1) {
                                    bloc.add(SetUnitCountEvent(
                                        count: --bloc.unitCount));
                                  }
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
                              BlocBuilder<ServicesBloc, ServicesState>(
                                builder: (context, state) {
                                  return Text(
                                    '${bloc.unitCount}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTapDown: (_) {
                                  bloc.add(
                                      SetUnitCountEvent(count: ++bloc.unitCount));
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
                                      bloc.add(ShowHintEvent(
                                          message:
                                              'Enter the area of Units/windows'));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            BlocBuilder<ServicesBloc, ServicesState>(
                              builder: (context, state) {
                                if (bloc.isHintShow) if (state is ShowHintState) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Text(
                                      'Please enter the total square area of the windows.',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600]),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      BlocBuilder<ServicesBloc, ServicesState>(
                        buildWhen: (previous, current) =>
                            current is IsFromRiyadhToggledState,
                        builder: (context, state) {
                          return Row(
                            children: [
                              Checkbox(
                                value: bloc.isFromRiyadh,
                                onChanged: (value) {
                                  bloc.add(ToggleIsFromRiyadhEvent());
                                },
                              ),
                              Text(
                                'Are you from Riyadh?',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
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
                          child: BlocListener<ServicesBloc, ServicesState>(
                            listener: (context, state) {
                              if (state is ServiceSubmittedState) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderScreen(
                                      images: bloc.images,
                                      order: OrderModel(
                                        orderId: orderId,
                                        customerId: locator
                                            .get<DataLayer>()
                                            .customer
                                            ?.customerId,
                                        serviceId: widget.service.serviceId,
                                        images: bloc.images
                                            .map((e) => e.path)
                                            .toList(),
                                        address: [
                                          convertToDMS(
                                              bloc.selectedLocation?.latitude ??
                                                  0.0),
                                          convertToDMS(
                                              bloc.selectedLocation?.longitude ??
                                                  0.0)
                                        ],
                                        squareMeters: double.tryParse(
                                                squareAreaController.text) ??
                                            0.0,
                                        reservationDate:
                                            DateTime.parse(bloc.selectedDate!),
                                        reservationTime: DateTime.now(),
                                        totalPrice: double.parse(
                                                squareAreaController.text) *
                                            3,
                                        orderDate: DateTime.now(),
                                        status: "pending",
                                      ),
                                      service: widget.service,
                                    ),
                                  ),
                                );
                              }
                              if (state is ServiceErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                bloc.squareMeters =
                                    double.parse(squareAreaController.text);
                                bloc.add(SubmitServicesEvent());
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
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
