import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uber_bagare/Pages/Home.dart';

import 'package:http/http.dart' as http;
import 'package:uber_bagare/Pages/FighterProfile.dart';

void main() {
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
