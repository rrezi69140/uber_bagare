import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:uber_bagare/Pages/Home.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uber_bagare/Pages/FighterProfile.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  MapboxOptions.setAccessToken(dotenv.get('MAPBOX_ACCESS_TOKEN'));
  runApp(MaterialApp(
    title: "UberBagarre",
    home: MyApp(),
  ));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override

  Widget build(BuildContext context) {
    return  Home();
  }
}
