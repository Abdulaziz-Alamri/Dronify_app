import 'dart:math';

import 'package:dronify_mngmt/Admin/admin_datalayer/admin_data_layer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

setup() async {
  // await GetStorage.init();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: '${dotenv.env['supabase_url']}',
    anonKey: '${dotenv.env['anon_key']}',
  );

  await locator.registerSingleton<AdminDataLayer>(AdminDataLayer());

  if (locator.get<AdminDataLayer>().externalKey == null) {
    locator.get<AdminDataLayer>().externalKey = Random().nextInt(999999).toString();
  }
}
