part of 'admin_home_bloc.dart';

@immutable
sealed class AdminHomeEvent {}

final class LoadEvent extends AdminHomeEvent{}

final class LoadUsersEvent extends AdminHomeEvent{}

final class LoadOrdersEvent extends AdminHomeEvent{}

final class LoadProfitsEvent extends AdminHomeEvent{
  
}
