import 'package:dronify/Data_layer/data_layer.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

setup() async {
  // await GetStorage.init();
  // await dotenv.load(fileName: ".env");
  // await Supabase.initialize(
  //   url: '${dotenv.env['supabase_url']}',
  //   anonKey: '${dotenv.env['anon_key']}',
  // );

  locator.registerSingleton<DataLayer>(DataLayer());

  // if (locator.get<DataLayer>().externalKey == null) {
  //   locator.get<DataLayer>().externalKey = Random().nextInt(999999).toString();
  // }
}