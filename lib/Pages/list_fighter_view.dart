import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'fighter_profile.dart';

class ListFighterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListFighterViewState();
}

class ListFighterViewState extends State<ListFighterView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetFighterProfile(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());  // Chargement en attente
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : veuillez contacter le support'));
        } else {
          var fighters = snapshot.data ?? [];

          // Trier les combattants par nombre de victoires, puis prendre les 5 premiers
          fighters.sort((a, b) => b['victory'].compareTo(a['victory']));
          var topFighters = fighters.take(5).toList();  // Prendre les 5 premiers

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Top 5 des Combattants",
                style: TextStyle(
                  color: Colors.white, // Changer la couleur du texte du titre en noir
                  fontWeight: FontWeight.bold,  // Ajouter un poids de texte pour le rendre plus visible
                ),
              ),
              backgroundColor: Colors.black,  // Conserver le fond noir pour l'AppBar
              centerTitle: true,
            ),
            backgroundColor: Colors.black, // Fond sombre de la page
            body: ListView.builder(
              itemCount: topFighters.length,
              itemBuilder: (context, index) {
                var fighter = topFighters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Card(
                    color: Colors.black,  // Fond noir pour chaque carte
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),  // Bords arrondis
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FighterPage(user: fighter);  // Naviguer vers la page de profil
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            // Avatar du combattant
                            CircleAvatar(
                              backgroundImage: NetworkImage(fighter['avatar_url'] ?? ''),
                              radius: 30,
                              backgroundColor: Colors.grey[800], // Fond gris si pas d'image
                            ),
                            SizedBox(width: 15),
                            // Informations du combattant
                            Expanded(  // Utilisation de Expanded pour éviter le dépassement
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${fighter['first_name']} ${fighter['last_name']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white, // Texte blanc pour le nom
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "${fighter['victory'] ?? 0} victoires-"
                                        "${fighter['defeat'] ?? 0} défaites-"
                                        "${fighter['ko'] ?? 0}KO",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70, // Texte un peu plus clair
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Distance
                            Text(
                              "${(fighter['latitude'] ?? 0).toStringAsFixed(2)} km",
                              style: TextStyle(
                                color: Colors.white70, // Texte gris clair pour la distance
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
