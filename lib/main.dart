import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: "UberBagarre",
    home: MyApp(),
  ));
}

Future<List<dynamic>> _getProfilePIctures() async {
  // Construction de l'URL a appeler
  var url = Uri.parse("https://randomuser.me/api/?inc=picture&results=8");
  // Appel
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<dynamic> combattants = data['results'];
    return combattants;
  } else {
    return [];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //var profilePicture = _getProfilePIctures();
    var combatantsJson = '''
  [
    {
      "nom": "John Fury",
      "victoires": 22,
      "defaites": 3,
      "ko": 18,
      "distance_km": 5.4,
      "image": "https://randomuser.me/api/portraits/med/men/34.jpg"
    },
    {
      "nom": "Alex Thunder",
      "victoires": 18,
      "defaites": 5,
      "ko": 12,
      "distance_km": 10.2,
      "image": "https://randomuser.me/api/portraits/med/men/35.jpg"
    },
    {
      "nom": "Mike Storm",
      "victoires": 30,
      "defaites": 2,
      "ko": 25,
      "distance_km": 8.7,
      "image": "https://randomuser.me/api/portraits/med/men/36.jpg"
    },
    {
      "nom": "Victor Blaze",
      "victoires": 15,
      "defaites": 7,
      "ko": 10,
      "distance_km": 3.6,
      "image": "https://randomuser.me/api/portraits/med/men/37.jpg"
    },
    {
      "nom": "Leo Dragon",
      "victoires": 27,
      "defaites": 4,
      "ko": 21,
      "distance_km": 12.3,
      "image": "https://randomuser.me/api/portraits/med/men/38.jpg"
    },
    {
      "nom": "Jake Iron",
      "victoires": 10,
      "defaites": 9,
      "ko": 6,
      "distance_km": 6.9,
     "image": "https://randomuser.me/api/portraits/med/men/39.jpg"
    },
    {
      "nom": "Bruce Titan",
      "victoires": 35,
      "defaites": 1,
      "ko": 28,
      "distance_km": 14.5,
      "image": "https://randomuser.me/api/portraits/med/men/40.jpg"
    },
    {
      "nom": "Rex Shadow",
      "victoires": 19,
      "defaites": 6,
      "ko": 14,
      "distance_km": 7.1,
      "image": "https://randomuser.me/api/portraits/med/men/41.jpg"
    }
  ]
  ''';
    List<dynamic> combattants = jsonDecode(combatantsJson);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Uber Bagarre"),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 30,
          children: [
            for (var Bagareuer in combattants)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage("${Bagareuer['image']}"),
                    //backgroundImage: NetworkImage("https://randomuser.me/api/portraits/med/men/41.jpg"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(" nom : ${Bagareuer['nom']}  "),
                      Text(
                          "${Bagareuer['victoires']} victoire -${Bagareuer['defaites']} defaite -${Bagareuer['ko']} ko")
                    ],
                  ),
                  Text("${Bagareuer['distance_km']}")
                ],
              ),
          ],
        ),
      ),
    );
  }
}
