import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapobox;
import 'package:provider/provider.dart';
import 'package:uber_bagare/providers/position_provider.dart';
import 'package:uber_bagare/services/fighter_service.dart';

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

  late mapobox.PointAnnotationManager pointAnnotationManager;

  _onMapCreated(mapobox.MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
  }

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
            onMapCreated: _onMapCreated,
          );
        },
      ),
    );
  }
}
