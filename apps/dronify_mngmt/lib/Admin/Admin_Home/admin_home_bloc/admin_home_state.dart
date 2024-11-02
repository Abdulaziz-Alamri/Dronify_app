part of 'admin_home_bloc.dart';

@immutable
sealed class AdminHomeState {}

final class AdminHomeInitial extends AdminHomeState {}

final class LoadingState extends AdminHomeState{}

final class LoadedState extends AdminHomeState{}

