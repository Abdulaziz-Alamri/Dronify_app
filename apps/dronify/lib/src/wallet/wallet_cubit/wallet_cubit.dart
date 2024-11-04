import 'package:bloc/bloc.dart';
import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/utils/setup.dart';
import 'package:meta/meta.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  Future<void> loadOrders() async {
    emit(WalletLoading());
    try {
      final orders = await locator.get<DataLayer>().fetchCustomerOrders();
      emit(WalletLoaded(orders));
    } catch (e) {
      emit(WalletError('Failed to load orders'));
    }
  }
}
