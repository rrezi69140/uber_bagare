
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../model/position_model.dart' as ModelPosition;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapobox;
import 'package:provider/provider.dart';
import '../model/position_model.dart';
import '../services/fighter_service.dart';

Future<void> updateUserInDatabase() async {







    SupabaseClient supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user != null) {
     try {
     var position = await ModelPosition.determinePosition();
    await supabase.from('users').upsert({
      'id': user.id,
      'Prenom': user.userMetadata?['full_name'],
      'Nom': user.userMetadata?['last_name'],
       'email': user.email,
      'avatar_url': user.userMetadata?['avatar_url'],
       'Victory': user.email,
        'defeat': user.email,
         'Longitude': position.longitude,
         'latitude':  position.latitude,
         'strengh': 0,
         'agility': 0,
         


         'inteligence': 0,
          'ko': 0,
         
    
         

    });

      print("Utilisateur mis à jour avec succès dans Supabase !");
     }
     catch (e) {
      print("Erreur lors de la mise à jour de l'utilisateur : $e");
    }
  }
}


 
