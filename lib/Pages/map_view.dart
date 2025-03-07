import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapobox;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../model/position_model.dart';
import '../services/user_service.dart';
import 'fighter_profile.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<StatefulWidget> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  mapobox.MapboxMap? mapboxMap;
  List<dynamic> users = [];
  late mapobox.PointAnnotationManager pointAnnotationManager;
  bool isMapReady = false;
  bool usersLoaded = false;

  @override
  void initState() {
    super.initState();
    GetUser();
  }

  Future<void> GetUser() async {
    try {
      users = await GetFighterProfile();
      print("✅ Utilisateurs récupérés : ${users.length} combattants trouvés.");

      setState(() {
        usersLoaded = true;
      });

      // Si la carte est prête, ajoute immédiatement les marqueurs
      if (isMapReady && mapboxMap != null) {
        await SetPointerPosition(mapboxMap!);
      }
    } catch (e) {
      print("❌ Erreur lors de la récupération des utilisateurs : $e");
    }
  }

  // Télécharger l'image de profil et la convertir en Uint8List
  Future<Uint8List?> _downloadImage(String imageUrl) async {
    try {
      print('🔍 Vérification de l\'URL : $imageUrl');
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        print('✅ Image téléchargée avec succès');
        return response.bodyBytes;
      } else {
        print("❌ Erreur de chargement de l'image : ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Erreur lors du téléchargement de l'image : $e");
      return null;
    }
  }

  // Ajouter des marqueurs avec les images des utilisateurs
  Future<void> SetPointerPosition(mapobox.MapboxMap mapboxMap) async {
    if (!isMapReady || users.isEmpty) return;

    try {
      pointAnnotationManager =
      await mapboxMap.annotations.createPointAnnotationManager();

      for (var user in users) {
        double lat = user['latitude'] ?? 0.0;
        double lon = user['longitude'] ?? 0.0;
        String? imageUrl = user['avatar_url']; // URL de l'image du user

        if (lat == 0.0 || lon == 0.0 || imageUrl == null) {
          print("⚠️ Aucune URL d'image trouvée pour ${user['first_name']}");
          continue;
        }

        print("📍 Ajout d'un marqueur pour ${user['last_name']} à ($lat, $lon)");

        Uint8List? imageData = await _downloadImage(imageUrl);

        if (imageData != null) {
          mapobox.PointAnnotationOptions pointAnnotationOptions =
          mapobox.PointAnnotationOptions(
            geometry: mapobox.Point(coordinates: mapobox.Position(lon, lat)),
            image: imageData,
            iconSize: 1,
            textField: "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}".trim().isEmpty
                ? "Nom ou prénom non disponible"
                : "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}".trim(),
// Ajuster la taille si nécessaire
          );

          await pointAnnotationManager.create(pointAnnotationOptions);
        }
      }

      print("✅ Tous les marqueurs avec photos ont été ajoutés !");
    } catch (e) {
      print("❌ Erreur lors de l'ajout des marqueurs : $e");
    }
  }

  // Fonction pour afficher le profil de l'utilisateur
  void showUserProfile(int userIndex) {
    // Affiche simplement le profil dans la console pour l'instant
    print("👤 Profil de ${users[userIndex]['first_name']} :");
    // Tu peux ajouter ici un écran ou un dialogue pour afficher plus d'infos sur l'utilisateur.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // La carte Mapbox en arrière-plan
          Consumer<PositionProvider>(
            builder: (context, positionProvider, child) {
              geolocator.Position? position = positionProvider.position;

              if (position == null) {
                return Center(child: CircularProgressIndicator());
              }

              return mapobox.MapWidget(
                cameraOptions: mapobox.CameraOptions(
                  center: mapobox.Point(
                    coordinates: mapobox.Position(
                      position.longitude,
                      position.latitude,
                    ),
                  ),
                  zoom: 15,
                  bearing: 50,
                  pitch: 60,
                ),
                onMapCreated: (mapboxMapInstance) async {
                  print("✅ Carte Mapbox initialisée !");
                  setState(() {
                    mapboxMap = mapboxMapInstance;
                    isMapReady = true;
                  });

                  if (usersLoaded) {
                    await SetPointerPosition(mapboxMapInstance);
                  }
                },
              );
            },
          ),

          // Ajouter des boutons sur la carte pour chaque utilisateur
          if (usersLoaded)
            ...users.asMap().entries.map((entry) {
              var user = entry.value;
              double lat = user['latitude'] ?? 0.0;
              double lon = user['longitude'] ?? 0.0;

              print("📍 Position de ${user['first_name']} -> Latitude: $lat, Longitude: $lon");

              return Positioned(
                // Utilisation de Mapbox pour placer le bouton directement sur la carte en fonction des coordonnées
                // Nous allons utiliser les coordonnées réelles des utilisateurs
                child: GestureDetector(
                  onTap: () {
                    print("👤 Profil de ${user['first_name']} cliqué");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FighterPage(user: user),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.blue.withOpacity(0.8), // Zone bleue visible pour les boutons
                    child: Icon(Icons.add_location, color: Colors.white, size: 40), // Agrandir l'icône
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
