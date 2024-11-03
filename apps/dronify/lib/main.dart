import 'dart:developer';

import 'package:dronify/layer/data_layer.dart';
import 'package:dronify/repository/auth_repository.dart';
import 'package:dronify/splash/splash_screen.dart';
import 'package:dronify/src/Auth/bloc/auth_bloc.dart';
import 'package:dronify/src/Order/rating_screen.dart';
import 'package:dronify/test.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await Future.delayed(Duration(seconds: 2));

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('${dotenv.env['onesignal_key']}');
  OneSignal.Notifications.requestPermission(true);

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
    OneSignal.Notifications.addClickListener((event) {
      if (event.notification.additionalData!['user_id'] ==
          supabase.auth.currentUser!.id) {
        navKey.currentState!
            .push(MaterialPageRoute(builder: (context) => RatingScreen(orderId: event.notification.additionalData!['order_id'])));
      }
    });
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            navigatorKey: navKey,
            debugShowCheckedModeBanner: false,
            home: SplashScreen());
      },
    );
  }
}
