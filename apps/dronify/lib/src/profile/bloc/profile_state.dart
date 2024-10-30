import 'package:dronify/models/customer_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final CustomerModel customer;
  ProfileLoaded(this.customer);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
