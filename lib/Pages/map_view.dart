import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapobox;
import 'package:provider/provider.dart';
import '../model/position_model.dart';
import '../services/fighter_service.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<StatefulWidget> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  mapobox.MapboxMap? mapboxMap;
  geolocator.Position? position;
  List<dynamic> users = [];
  mapobox.CameraOptions? camera;

  geolocator.Position? get userPosition => position;

  GetUser() async {
    users = await GetFighterProfile();
  }

  SetPointerPosition(
      geolocator.Position cursorPosition, mapobox.MapboxMap mapboxMap) async {
    print('Position du curseur : $cursorPosition');

    // Assurez-vous que mapboxMap est non nul avant de l'utiliser
    if (mapboxMap != null) {
      print('Position du curseurr : $cursorPosition');
      final ByteData bytes =
          await rootBundle.load('assets/iconNavigationMarker.png');
      final Uint8List imageData = bytes.buffer.asUint8List();
      pointAnnotationManager =
          await mapboxMap.annotations.createPointAnnotationManager();
      mapobox.PointAnnotationOptions pointAnnotationOptions =
          mapobox.PointAnnotationOptions(
        geometry: mapobox.Point(
            coordinates: mapobox.Position(
                cursorPosition.longitude, cursorPosition.latitude)),
        image: imageData,
        iconSize: 10,
      );
      pointAnnotationManager.create(pointAnnotationOptions);
    }
  }

  late mapobox.PointAnnotationManager pointAnnotationManager;

  @override
  void initState() {
    super.initState();

    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<PositionProvider>(
        builder: (context, userPosition, child) {
          geolocator.Position? position = userPosition.position;

          if (position == null) {
            return CircularProgressIndicator();
          }
          return mapobox.MapWidget(
            cameraOptions: mapobox.CameraOptions(
              center: mapobox.Point(
                  coordinates: mapobox.Position(
                position.longitude,
                position.latitude,
              )),
              zoom: 15,
              bearing: 50,
              pitch: 60,
            ),
            onMapCreated: (mapboxMapInstance) {
              setState(() {
                mapboxMap = mapboxMapInstance;
              });

              // Maintenant que mapboxMap est non nul, vous pouvez appeler SetPointerPosition
              SetPointerPosition(position, mapboxMap!);
            },
          );
        },
      ),
    );
  }
}
