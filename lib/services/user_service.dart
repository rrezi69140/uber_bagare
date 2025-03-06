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
  print(Supabase.instance.client);

  final user = supabase.auth.currentUser;
  if (user != null) {
    try {
      var position = await ModelPosition.determinePosition();
      await supabase.from('users').upsert({
        'id': user.id, // Doit être un UUID
        'first_name': user.userMetadata?['full_name'],
        'last_name': user.userMetadata?['last_name'],
        'email': user.email,
        'avatar_url': user.userMetadata?['avatar_url'],
        'longitude': position.longitude,
        'latitude': position.latitude,
      });

      print("Utilisateur mis à jour avec succès dans Supabase !");
    } catch (e) {
      print("Erreur lors de la mise à jour de l'utilisateur : $e");
    }
  }
}
