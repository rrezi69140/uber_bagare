import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uber_bagare/Pages/FighterProfile.dart';

Future<List<dynamic>> getProfilePIctures() async {
  // Construction de l'URL a appeler
  var url = Uri.parse(
      "https://randomuser.me/api/?results=8"); // utilisation de l'api random user pour génerer les information  des utilisateur
  // Appel
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return data['results'];
  } else {
    return [];
  }
}
class Home extends StatelessWidget {
  const Home({super.key});

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
                      child: Text('Error: veuiller contacter le support '));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 30,
                    children: [
                      for (var bagareuer in fighter.data!)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const FighterPage(title: 'SecondPage');
                            }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 15,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "${bagareuer['picture']['medium']}"),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      " nom : ${bagareuer['name']['first']}  ${bagareuer['name']['last']}   "), // crée des valeur fictive
                                  Text(
                                      "${bagareuer['dob']['age'] / 2.toInt()} victoire -- ${bagareuer['dob']['age'] % 2.toInt()} defaite -- ${bagareuer['dob']['age'] / 10.toInt()} KO")
                                ],
                              ),
                              Text("${bagareuer['dob']['age']} km")
                            ],
                          ),
                        )
                    ],
                  );
                }
              }
            }),
      ),
    );
  }
}
