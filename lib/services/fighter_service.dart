import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> GetFighterProfile() async {
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
