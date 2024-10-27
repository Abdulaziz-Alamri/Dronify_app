import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  int selectedIndex = 0;
  bool value = false;
  final ImagePicker picker = ImagePicker();
  int unitCount = 1;
  bool isFromRiyadh = false;
  LatLng? currentLocation;
  LatLng? selectedLocation;
  List<XFile>? images = [];
  String? selectedDate;

  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<SelectRadioEvent>(selectRadio);
    on<PickImageEvent>(pickImage);
    on<RemovedImageEvent>(removeImage);
    on<PickDateEvent>(pickDate);
    on<FetchLocationEvent>(getLocation);
    on<PinLocationEvent>(getNewLocation);
    on<SetUnitCountEvent>(setUnitCount);
    on<ToggleIsFromRiyadhEvent>(toggleSwitch);
    on<SubmitSubscriptionEvent>(subscribe);
  }

  FutureOr<void> selectRadio(
      SelectRadioEvent event, Emitter<SubscriptionState> emit) {
    emit(SelectedRadioState(
        selectedIndex: event.selectedIndex, value: event.value));
  }

  FutureOr<void> pickImage(
      PickImageEvent event, Emitter<SubscriptionState> emit) async {
    emit(Loadedstate());
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty && pickedFiles.length <= 4) {
      images = pickedFiles;
      emit(ImagesUpdatedState(images: images!));
    } else {
      emit(SubscriptionErrorState(
          message: "You can upload up to 4 images only."));
    }
  }

  FutureOr<void> removeImage(
      RemovedImageEvent event, Emitter<SubscriptionState> emit) {
    emit(Loadedstate());
    emit(ImagesUpdatedState(images: event.images));
  }

  FutureOr<void> pickDate(
      PickDateEvent event, Emitter<SubscriptionState> emit) async {
    emit(Loadedstate());
    DateTime? picked = await showDatePicker(
      context: event.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      emit(DateSelectedState(selectedDate: selectedDate!));
    }
  }

  FutureOr<void> getLocation(
      FetchLocationEvent event, Emitter<SubscriptionState> emit) async {
    if (currentLocation == null) {
      Position position = await getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    if (selectedLocation == null) {
      print('here');
      emit(LocationFetchedState(location: currentLocation!));
    } else {
      emit(LocationFetchedState(location: selectedLocation!));
    }
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  FutureOr<void> getNewLocation(
      PinLocationEvent event, Emitter<SubscriptionState> emit) async {
    selectedLocation = event.point;
    emit(LocationFetchedState(location: selectedLocation!));
  }

  FutureOr<void> setUnitCount(
      SetUnitCountEvent event, Emitter<SubscriptionState> emit) async {
    unitCount = event.count;
    emit(UnitCountUpdatedState(unitCount: unitCount));
  }

  FutureOr<void> toggleSwitch(
      ToggleIsFromRiyadhEvent event, Emitter<SubscriptionState> emit) async {
    isFromRiyadh = !isFromRiyadh;
    emit(IsFromRiyadhToggledState(isFromRiyadh: isFromRiyadh));
  }

  FutureOr<void> subscribe(
      SubmitSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    if (isFromRiyadh && currentLocation != null) {
      emit(SubscriptionSubmittedState());
    } else {
      emit(SubscriptionErrorState(
          message: "Please fill in all required details."));
    }
  }
}
