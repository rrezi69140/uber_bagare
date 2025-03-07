import 'dart:typed_data';
import 'package:flutter/material.dart';
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
  int? selectedUserIndex; // Index de l'utilisateur sélectionné dans la liste

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

      if (isMapReady && mapboxMap != null) {
        await SetPointerPosition(mapboxMap!);
      }
    } catch (e) {
      print("❌ Erreur lors de la récupération des utilisateurs : $e");
    }
  }

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

  Future<void> SetPointerPosition(mapobox.MapboxMap mapboxMap) async {
    if (!isMapReady || users.isEmpty) return;

    try {
      pointAnnotationManager =
      await mapboxMap.annotations.createPointAnnotationManager();

      for (var user in users) {
        double lat = user['latitude'] ?? 0.0;
        double lon = user['longitude'] ?? 0.0;
        String? imageUrl = user['avatar_url'];
        String fullName =
        "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}"
            .trim()
            .isEmpty
            ? "Nom ou prénom non disponible"
            : "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}"
            .trim();

        if (lat == 0.0 || lon == 0.0) {
          print("⚠️ Coordonnées invalides pour ${user['first_name']}");
          continue;
        }

        print(
          "📍 Ajout d'un marqueur pour ${user['last_name']} à ($lat, $lon)",
        );

        Uint8List? imageData =
        imageUrl != null ? await _downloadImage(imageUrl) : null;

        mapobox.PointAnnotationOptions pointAnnotationOptions =
        mapobox.PointAnnotationOptions(
          geometry: mapobox.Point(coordinates: mapobox.Position(lon, lat)),
          image: imageData,
          iconSize: 1,
          textField: fullName,
          textOffset: [0, 2],
          textAnchor: mapobox.TextAnchor.TOP,
          textColor: Colors.black.value, // Texte en noir
          textHaloColor: Colors.white.value, // Contour blanc
          textHaloWidth: 2, // Largeur du contour
        );

        await pointAnnotationManager.create(
          pointAnnotationOptions,
        );
      }

      print("✅ Tous les marqueurs avec photos ont été ajoutés !");
    } catch (e) {
      print("❌ Erreur lors de l'ajout des marqueurs : $e");
    }
  }

  void _centerMapOnUser(int index) {
    if (index >= 0 && index < users.length && mapboxMap != null) {
      var user = users[index];
      double lat = user['latitude'] ?? 0.0;
      double lon = user['longitude'] ?? 0.0;

      if (lat != 0.0 && lon != 0.0) {
        mapboxMap!.setCamera(
          mapobox.CameraOptions(
            center: mapobox.Point(coordinates: mapobox.Position(lon, lat)),
            zoom: 15,
            bearing: 50,
            pitch: 60,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<PositionProvider>(
            builder: (context, positionProvider, child) {
              geolocator.Position? position = positionProvider.position;

              if (position == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return mapobox.MapWidget(
                styleUri: mapobox.MapboxStyles.DARK, // Style sombre
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
          if (usersLoaded)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[800]!.withOpacity(0.8), // Fond sombre
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Ombre noire
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: users.map((user) {
                      int index = users.indexOf(user);
                      bool isSelected = selectedUserIndex == index;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedUserIndex == index) {
                                // Re-cliquer pour voir le profil
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FighterPage(user: user),
                                  ),
                                );
                              } else {
                                // Sélectionner un utilisateur
                                selectedUserIndex = index;
                              }
                            });
                            _centerMapOnUser(index);
                          },
                          child: Container(
                            width: 120, // Largeur maximale pour chaque bouton
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.8) : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (user['avatar_url'] != null)
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Forme ronde
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.white, // Bordure bleue si sélectionné
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        user['avatar_url'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}",
                                  textAlign: TextAlign.center, // Centrer le texte
                                  maxLines: 1, // Limiter à 1 ligne
                                  overflow: TextOverflow.ellipsis, // Ajouter des points de suspension si le texte est trop long
                                  style: TextStyle(
                                      fontSize: 12, // Taille de texte réduite
                                      color: isSelected ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Voir Profil',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
