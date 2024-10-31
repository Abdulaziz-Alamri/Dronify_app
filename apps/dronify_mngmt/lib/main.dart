
import 'package:dronify_mngmt/Auth/bloc/auth_bloc.dart';
import 'package:dronify_mngmt/Auth/first_screen.dart';
import 'package:dronify_mngmt/Bottom_Nav/bottom_nav.dart';
import 'package:dronify_mngmt/Employee_Home/bloc/orders_bloc_bloc.dart';
import 'package:dronify_mngmt/Employee_Home/employee_home.dart';
import 'package:dronify_mngmt/repository/auth_repository.dart';

import 'package:dronify_mngmt/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await Future.delayed(Duration(seconds: 2));
  // await supabase.auth.signOut();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false, home: FirstScreen());
      },
    );
  }
}
