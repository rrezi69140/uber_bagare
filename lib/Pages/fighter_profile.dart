import 'package:flutter/material.dart';

import 'home.dart';

class FighterPage extends StatelessWidget {
  const FighterPage({Key? key, required this.user}) : super(key: key);
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    // On récupère les données de l'utilisateur (combattant)
    var firstName = user['first_name'] ?? "Nom inconnu";
    var lastName = user['last_name'] ?? "Prénom inconnu";
    var avatarUrl = user['avatar_url'] ?? '';
    var victory = user['victory'] ?? 0;
    var defeat = user['defeat'] ?? 0;
    var ko = user['ko'] ?? 0;
    var distance = user['latitude'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("$firstName $lastName"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar et informations principales
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            SizedBox(height: 20),
            Text(
              "$firstName $lastName",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              "$victory victoires - $defeat défaites - $ko KO",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "Localisation: ${distance.toStringAsFixed(2)} km",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Compétences du combattant
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Compétences :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Compétence 1: Boxe", style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Compétence 2: Judo", style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Compétence 3: Muay Thai", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 252, 252, 252),
        child: Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Home();
              }));
            },
            child: const Text('Go Back'),
          ),
        ),
      ),
    );
  }
}
