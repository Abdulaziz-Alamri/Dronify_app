import 'package:bloc/bloc.dart';
import 'package:dronify_mngmt/Employee_Order/bloc/order_event.dart';
import 'package:dronify_mngmt/Employee_Order/bloc/order_state.dart';
import 'package:dronify_mngmt/models/order_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final SupabaseClient supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  OrderBloc() : super(OrderLoading()) {
    on<FetchOrderData>(_onFetchOrderData);
    on<PickImages>(_onPickImages);
  }

  Future<void> _onFetchOrderData(
      FetchOrderData event, Emitter<OrderState> emit) async {
    try {
      final response = await supabase
          .from('orders')
          .select(
              '*, app_user!inner(name, phone), service(name, description), address(latitude, longitude), images(image_url)')
          .eq('order_id', event.orderId)
          .maybeSingle();

      print('Supabase response: $response');

      if (response == null) {
        emit(OrderError('Order data not found'));
        return;
      }

      OrderModel orderData = OrderModel.fromJson(response);

      double? latitude;
      double? longitude;

      if (orderData.address != null && orderData.address!.isNotEmpty) {
        latitude = orderData.address![0]['latitude'] is String
            ? _dmsToDecimal(orderData.address![0]['latitude'])
            : orderData.address![0]['latitude'];

        longitude = orderData.address![0]['longitude'] is String
            ? _dmsToDecimal(orderData.address![0]['longitude'])
            : orderData.address![0]['longitude'];
      }

      LatLng? location;
      if (latitude != null && longitude != null) {
        location = LatLng(latitude, longitude);
      } else {
        print('Warning: Latitude or longitude not found in response.');
      }

      emit(OrderLoaded(
        orderData: orderData,
        location: location,
      ));
    } catch (error) {
      print('Error fetching order data from Supabase: $error');
      emit(OrderError('Failed to load order data: $error'));
    }
  }

  Future<void> _onPickImages(PickImages event, Emitter<OrderState> emit) async {
    try {
      final pickedFiles = await _picker.pickMultiImage(limit: 4);
      if (pickedFiles != null) {
        emit(OrderLoaded(
          orderData: (state as OrderLoaded).orderData,
          location: (state as OrderLoaded).location,
          selectedImages: pickedFiles,
        ));
      }
    } catch (error) {
      print("Error picking images: $error");
      emit(OrderError("Failed to pick images"));
    }
  }

  double? _dmsToDecimal(String dms) {
    final dmsPattern =
        RegExp(r"""(\d+)[°]\s*(\d+)[']\s*(\d+\.?\d*)["]?\s*([NSEW])?""");
    final match = dmsPattern.firstMatch(dms);

    if (match != null) {
      final degrees = double.parse(match.group(1)!);
      final minutes = double.parse(match.group(2)!);
      final seconds = double.parse(match.group(3)!);
      final direction = match.group(4);

      double decimal = degrees + (minutes / 60) + (seconds / 3600);
      if (direction == 'S' || direction == 'W') {
        decimal = -decimal;
      }
      return decimal;
    }
    return null;
  }
}
