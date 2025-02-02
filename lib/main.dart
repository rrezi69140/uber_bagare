import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: "UberBagarre",
    home: MyApp(),
  ));
}

Future<List<dynamic>> getProfilePIctures() async {
  // Construction de l'URL a appeler
  var url = Uri.parse("https://randomuser.me/api/?results=8");
  // Appel
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return data['results'];
  } else {
    return [];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Uber Bagarre"),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: Color.fromARGB(255, 0, 0, 0),
        color: const Color.fromARGB(255, 252, 252, 252),
        child: Text("ahhh"),
      ),
      body: Center(
        child: FutureBuilder(
            future: getProfilePIctures(),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> fighter) {
              if (fighter.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Please wait its loading...'));
              } else {
                if (fighter.hasError) {
                  return Center(
                      child: Text(
                          'Error: veuiller contacter le support '));
                } else {
             
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 30,
                    children: [
                      for (var bagareuer in fighter.data!)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          
                          spacing: 15,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${bagareuer['picture']['medium']}"),
                       
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(" nom : ${bagareuer['name']['first']}  ${bagareuer['name']['last']}   "),
                                Text(
                                    "${bagareuer['dob']['age']/2.toInt()} victoire -- ${bagareuer['dob']['age']%2.toInt()} defaite -- ${bagareuer['dob']['age']/10.toInt()} KO")
                              ],
                            ),
                            Text("${bagareuer['dob']['age']} km")
                          ],
                        ),
                    ],
                  );
                }
              }
            }),
      ),
    );
  }
}
