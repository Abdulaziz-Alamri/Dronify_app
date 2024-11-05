import 'package:bloc/bloc.dart';
import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/models/order_model.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:dronify/utils/setup.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
    late final RealtimeChannel channel;
  double balance = 0;
  WalletCubit() : super(WalletInitial());

  Future<void> loadOrders() async {
    emit(WalletLoading());
    try {
      final orders = await locator.get<DataLayer>().fetchCustomerOrders();
      final currentBalance = await supabase
          .from('app_user')
          .select('balance')
          .eq('user_id', supabase.auth.currentUser!.id)
          .single();
      balance = double.parse(currentBalance['balance'].toString());
      emit(WalletLoaded(orders));
    } catch (e) {
      emit(WalletError('Failed to load orders'));
    }
  }
}
