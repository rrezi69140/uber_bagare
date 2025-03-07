import 'package:flutter/material.dart';
import 'list_fighter_view.dart';
import 'map_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uber_bagare/services/user_service.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    updateUserInDatabase();
  }

  SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black, // Fond noir pour l'AppBar
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.star, // Icône plus pertinente pour "Top Fighters"
                  size: 50,
                  color: Colors.white, // Icône en blanc
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.location_on, // Icône pour la carte
                  size: 50,
                  color: Colors.white, // Icône en blanc
                ),
              ),
            ],
          ),
          title: const Center(
            child: Text(
              "Uber Bagarre",
              style: TextStyle(
                color: Colors.white, // Texte en blanc pour contraster avec le fond noir
                fontWeight: FontWeight.bold, // Ajoute du poids au texte
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Center(child: ListFighterView()),
            Center(child: MapView())
          ],
        ),
      ),
    );
  }
}
