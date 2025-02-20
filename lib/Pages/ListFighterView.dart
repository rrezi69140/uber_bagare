import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FighterProfile.dart';

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

class ListFighterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListFighterViewState();
}

class ListFighterViewState extends State<ListFighterView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProfilePIctures(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> fighter) {
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
                          return FighterPage(user: bagareuer);
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
                                  " nom : ${bagareuer['name']['first']}  ${bagareuer['name']['last']}   "),
                              // crée des valeur fictive
                              Text(
                                  "${bagareuer['dob']['age'] / 2.toInt()} victoire -- ${bagareuer['dob']['age'] % 2.toInt()} defaite -- ${bagareuer['dob']['age'] / 10.toInt()} KO")
                            ],
                          ),
                          Expanded(
                            child: Text(
                              "${bagareuer['dob']['age']} km",
                            ),
                          )
                        ],
                      ),
                    )
                ],
              );
            }
          }
        });
  }
}
