import 'package:dronify/repository/auth_repository.dart';
import 'package:dronify/splash/splash_screen.dart';
import 'package:dronify/src/Auth/bloc/auth_bloc.dart';
import 'package:dronify/src/Auth/first_screen.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  // await saveOrder(
  //     customerId: '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd',
  //     employeeId: '4252d26b-19f6-4f98-9f5a-a3ddc18f2fdd',
  //     serviceId: 1,
  //     squareMeters: 500,
  //     reservationDate: DateTime.now(),
  //     reservationTime: TimeOfDay.now(),
  //     totalPrice: 1000,
  //     imageUrls: [],
  //     latitude: '21323',
  //     longitude: '21312312'
  //     );
  // runApp(const MainApp());
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
            debugShowCheckedModeBanner: false, home: SplashScreen());
      },
    );
  }
}
