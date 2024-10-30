import 'package:bloc/bloc.dart';
import 'package:dronify/utils/db_operations.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:dronify/models/customer_model.dart';
import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/repository/auth_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataLayer dataLayer;
  final AuthRepository authRepository = AuthRepository();

  ProfileBloc(
    this.dataLayer,
  ) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final customer =
          await dataLayer.getCustomer(supabase.auth.currentUser!.id);
      if (customer != null) {
        dataLayer.saveCustomerData(customer);
        emit(ProfileLoaded(customer));
      } else {
        emit(ProfileError("No customer data found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      await authRepository.logout();
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError('Logout failed: ${e.toString()}'));
    }
  }
}
