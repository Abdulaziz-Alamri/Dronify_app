import 'dart:io';

import 'package:dronify/src/Subscription/custom_sub_card.dart';
import 'package:dronify/src/Subscription/subscription_bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sizer/sizer.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List months = [3, 6, 9];
    List descriptions = [
      'Includes 6 visits (two visits each month) to maintain your building’s appearance.',
      'Includes 12 visits (two visits each month), perfect for ongoing cleanliness with fewer subscriptions.',
      'Includes 18 visits (two visits each month), an excellent choice for those needing consistent maintenance at a great value.'
    ];
    List<double> prices = [1500, 2500, 4000];
    TextEditingController squareAreaController = TextEditingController();
    final _formKey = GlobalKey<FormState>();


    return BlocProvider(
      create: (context) => SubscriptionBloc()..add(FetchLocationEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<SubscriptionBloc>();
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
                        ...List.generate(3, (index) {
                          return BlocBuilder<SubscriptionBloc, SubscriptionState>(
                            buildWhen: (previous, current) => current is SelectedRadioState,
                            builder: (context, state) {
                              if (state is SelectedRadioState) {
                                return CustomSubCard(
                                  duration: months[index],
                                  description: descriptions[index],
                                  price: prices[index],
                                  index: index,
                                  selectedIndex: state.selectedIndex,
                                  value: state.value,
                                  bloc: bloc,
                                );
                              }
                              return CustomSubCard(
                                  duration: months[index],
                                  description: descriptions[index],
                                  price: prices[index],
                                  index: index,
                                  selectedIndex: -1,
                                  value: false,
                                  bloc: bloc);
                            },
                          );
                        }),
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
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () {
                            bloc.add(PickImageEvent());
                          },
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
                        BlocBuilder<SubscriptionBloc, SubscriptionState>(
                          buildWhen: (previous, current) => current is ImagesUpdatedState,
                          builder: (context, state) {
                            if (state is ImagesUpdatedState && state.images.isNotEmpty) {
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
                                                state.images.removeAt(index);
                                                bloc.add(RemovedImageEvent(
                                                    images: state.images));
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
                              );
                            }
                            return Text('No Images Chosen');
                          },
                        ),
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
                        BlocBuilder<SubscriptionBloc, SubscriptionState>(
                          buildWhen: (previous, current) => current is LocationFetchedState && previous is! PinnedLocationState,
                          builder: (context, state) {
                            if (state is LocationFetchedState) {
                              return Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: state.location,
                                    maxZoom: 15.0,
                                    onTap: (tapPosition, point) {
                                      bloc.add(PinLocationEvent(
                                          tapPosition: tapPosition, point: point));
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
                              );
                            }
                            return CircularProgressIndicator();
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
                        BlocBuilder<SubscriptionBloc, SubscriptionState>(
                                   buildWhen: (previous, current) => current is DateSelectedState,
                          builder: (context, state) {
                            if (state is DateSelectedState) {
                              return Text(
                                'Selected date: ${bloc.selectedDate}',
                                style:
                                    TextStyle(fontSize: 16.sp, color: Colors.black),
                              );
                            }
                            return SizedBox.shrink();
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
                                  '${bloc.unitCount}',
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
                              //       style: TextStyle(
                              //           fontSize: 12.sp, color: Colors.grey[600]),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        BlocBuilder<SubscriptionBloc, SubscriptionState>(
                           buildWhen: (previous, current) => current is IsFromRiyadhToggledState,
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
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            );
                          },
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
                                    bloc.isFromRiyadh &&
                                    bloc.currentLocation != null) {
                                  // show success messaage
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please fill in all required fields')),
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
      ),
    );
  }
  String convertToDMS(double coordinate) {
    int degrees = coordinate.floor();
    double minutesWithDecimal = (coordinate - degrees) * 60;
    int minutes = minutesWithDecimal.floor();
    double seconds = (minutesWithDecimal - minutes) * 60;

    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }
}
