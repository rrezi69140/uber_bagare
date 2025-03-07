import 'package:flutter/material.dart';
import 'home.dart';

class FighterPage extends StatelessWidget {
  const FighterPage({Key? key, required this.user}) : super(key: key);
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    // Récupérer les données de l'utilisateur (combattant)
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
        backgroundColor: Colors.black, // Couleur sombre pour l'AppBar
        centerTitle: true,
      ),
      backgroundColor: Colors.black, // Fond sombre de la page
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar et informations principales
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: Colors.grey[800], // Fond gris si image indisponible
              ),
              SizedBox(height: 20),
              Text(
                "$firstName $lastName",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$victory victoires - $defeat défaites - $ko KO",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Localisation: ${distance.toStringAsFixed(2)} km",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 30),

              // Stats - Affichage sous forme de cartes avec des icônes
              _buildStatCard("Victoires", victory, Icons.thumb_up),
              _buildStatCard("Défaites", defeat, Icons.thumb_down),
              _buildStatCard("KO", ko, Icons.warning),

              SizedBox(height: 30),

              // Compétences du combattant
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Compétences :",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildSkill("Compétence 1: Boxe"),
                  _buildSkill("Compétence 2: Judo"),
                  _buildSkill("Compétence 3: Muay Thai"),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Home();
              }));
            },
            child: const Text(
              'Retour à l\'accueil',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour construire une carte avec les statistiques
  Widget _buildStatCard(String title, int value, IconData icon) {
    return Card(
      color: Colors.grey[850],
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 30,
            ),
            SizedBox(width: 20),
            Text(
              "$title : $value",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour afficher les compétences
  Widget _buildSkill(String skill) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        skill,
        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
      ),
    );
  }
}
