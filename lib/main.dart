import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'Pages/home.dart';
import 'model/position_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  MapboxOptions.setAccessToken(dotenv.get('MAPBOX_ACCESS_TOKEN'));

  runApp(
    ChangeNotifierProvider(
      create: (context) => PositionProvider(),
      child: MaterialApp(
        title: "UberBagarre",
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
