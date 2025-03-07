import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapobox;
import 'package:provider/provider.dart';
import '../model/position_model.dart';
import '../services/user_service.dart';

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

  // Récupération des utilisateurs
  Future<void> GetUser() async {
    try {
      users = await GetFighterProfile();
      print("✅ Utilisateurs récupérés : ${users.length} combattants trouvés.");

      setState(() {
        usersLoaded = true;
      });

      // Si la carte est déjà prête, on ajoute les marqueurs immédiatement
      if (isMapReady && mapboxMap != null) {
        await SetPointerPosition(mapboxMap!);
      }
    } catch (e) {
      print("❌ Erreur lors de la récupération des utilisateurs : $e");
    }
  }

  // Ajouter des marqueurs pour chaque combattant
  Future<void> SetPointerPosition(mapobox.MapboxMap mapboxMap) async {
    if (!isMapReady || users.isEmpty) return;

    try {
      final ByteData bytes =
      await rootBundle.load('assets/images/iconNavigationMarker.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      pointAnnotationManager =
      await mapboxMap.annotations.createPointAnnotationManager();

      // Ajouter un marqueur pour chaque combattant
      for (var user in users) {
        double lat = user['latitude'] ?? 0.0;
        double lon = user['longitude'] ?? 0.0;

        if (lat == 0.0 || lon == 0.0) continue; // Ignore les mauvaises données

        print("📍 Ajout d'un marqueur pour ${user['first_name']} à ($lat, $lon)");

        mapobox.PointAnnotationOptions pointAnnotationOptions =
        mapobox.PointAnnotationOptions(
          geometry: mapobox.Point(coordinates: mapobox.Position(lon, lat)),
          image: imageData,
          iconSize: 0.2,
        );

        await pointAnnotationManager.create(pointAnnotationOptions);
      }

      print("✅ Tous les marqueurs ont été ajoutés !");
    } catch (e) {
      print("❌ Erreur lors de l'ajout des marqueurs : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<PositionProvider>(
        builder: (context, positionProvider, child) {
          geolocator.Position? position = positionProvider.position;

          if (position == null) {
            return CircularProgressIndicator();
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

              // Ajouter les marqueurs après chargement de la carte et des utilisateurs
              if (usersLoaded) {
                await SetPointerPosition(mapboxMapInstance);
              }
            },
          );
        },
      ),
    );
  }
}
