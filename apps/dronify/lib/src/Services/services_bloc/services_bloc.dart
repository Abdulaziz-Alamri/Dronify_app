import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];
  int unitCount = 1;
  LatLng? currentLocation;
  LatLng? selectedLocation;
  String? selectedDate;
  double? squareMeters;
  bool isHintShow = false;
  bool isFromRiyadh = false;
  double totalPrice = 0;
  ServicesBloc() : super(ServicesInitial()) {
    on<PickImageEvent>(pickImage);
    on<RemovedImageEvent>(removeImage);
    on<FetchLocationEvent>(getLocation);
    on<PickDateEvent>(pickDate);
    on<PinLocationEvent>(pinLocation);
    on<SetUnitCountEvent>(setUnitCount);
    on<ShowHintEvent>(showHint);
    on<SetAreaEvent>(setArea);
    on<ToggleIsFromRiyadhEvent>(toggleSwitch);
    on<SubmitServicesEvent>(submitServices);
  }


  FutureOr<void> pickImage(PickImageEvent event, Emitter<ServicesState> emit) async {
    emit(Loadedstate());
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty && pickedFiles.length <= 4) {
      images = pickedFiles;
      emit(ImagesUpdatedState(images: images));
    } else {
      emit(ServiceErrorState(message: "You can upload up to 4 images only."));
    }
  }

  FutureOr<void> removeImage(RemovedImageEvent event, Emitter<ServicesState> emit) {
    emit(Loadedstate());
    emit(ImagesUpdatedState(images: event.images));
  }

  FutureOr<void> getLocation(FetchLocationEvent event, Emitter<ServicesState> emit) async {
    if (currentLocation == null) {
      Position position = await getCurrentLocation();
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    if (selectedLocation == null) {
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
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  FutureOr<void> pickDate(PickDateEvent event, Emitter<ServicesState> emit) async {
  DateTime? pickedDate = await showDatePicker(
    context: event.context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    selectedDate = pickedDate.toIso8601String();
    emit(DateSelectedState(selectedDate: selectedDate!));
  } else {
    emit(ServiceErrorState(message: "No date was selected."));
  }
}

  FutureOr<void> pinLocation(PinLocationEvent event, Emitter<ServicesState> emit) {
    selectedLocation = event.point;
    emit(PinnedLocationState(location: selectedLocation!));
  }

  FutureOr<void> setUnitCount(SetUnitCountEvent event, Emitter<ServicesState> emit) {
    unitCount = event.count;
    emit(UnitCountUpdatedState(unitCount: unitCount));
  }

  FutureOr<void> showHint(ShowHintEvent event, Emitter<ServicesState> emit) {
    isHintShow = true;
    emit(ShowHintState(message: event.message));
  }

  FutureOr<void> setArea(SetAreaEvent event, Emitter<ServicesState> emit) {
    squareMeters = event.area;
    emit(AreaSetState(area: event.area));
  }

  FutureOr<void> toggleSwitch(ToggleIsFromRiyadhEvent event, Emitter<ServicesState> emit) {
    isFromRiyadh = !isFromRiyadh;
    emit(IsFromRiyadhToggledState(isFromRiyadh: isFromRiyadh));
  }

  FutureOr<void> submitServices(SubmitServicesEvent event, Emitter<ServicesState> emit) async {
    if (isFromRiyadh && selectedDate != null && selectedLocation != null && images.isNotEmpty) {
      emit(ServiceSubmittedState());
    } else {
      emit(ServiceErrorState(message: "Please fill in all required details."));
    }
  }
}
