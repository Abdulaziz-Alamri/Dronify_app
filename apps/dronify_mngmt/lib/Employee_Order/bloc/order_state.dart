// order_state.dart
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:dronify_mngmt/models/order_model.dart';

abstract class OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final OrderModel orderData;
  final LatLng? location;
  final List<XFile> selectedImages;

  OrderLoaded({
    required this.orderData,
    this.location,
    this.selectedImages = const [],
  });
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
