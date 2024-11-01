import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_home_event.dart';
part 'admin_home_state.dart';

class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final List<int> profits = [0, 500, 1500, 1000, 4000];
  AdminHomeBloc() : super(AdminHomeInitial()) {
    // on<>();
  }
}
