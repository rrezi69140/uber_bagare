import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uber_bagare/Pages/Home.dart';
import 'package:http/http.dart' as http;
class FighterPage extends StatelessWidget {
  const FighterPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){ return const Home();}));
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}