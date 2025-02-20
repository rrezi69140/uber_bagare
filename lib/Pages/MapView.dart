import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:provider/provider.dart';
import 'package:uber_bagare/Pages/ListFighterView.dart';

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapViewState();
}

Future<geolocator.Position> _determinePosition() async {
  bool serviceEnabled;
  geolocator.LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await geolocator.Geolocator.checkPermission();
  if (permission == geolocator.LocationPermission.denied) {
    permission = await geolocator.Geolocator.requestPermission();
    if (permission == geolocator.LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == geolocator.LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await geolocator.Geolocator.getCurrentPosition();
}

class PositionProvider extends ChangeNotifier {
  geolocator.Position? position;

  geolocator.Position? get userPosition => position;

  PositionProvider() {
    getLocalisation();
  }

  void getLocalisation() async {
    position = await _determinePosition();
    notifyListeners();
  }
}

class MapViewState extends State<MapView> {
  @override
  mapbox.MapboxMap? mapboxMap;
  geolocator.Position? position;
  List<dynamic> Users = [];
  mapbox.CameraOptions? camera;

  geolocator.Position? get userPosition => position;

  _GetUser() async {
    Users = await getProfilePIctures();
  }

  late mapbox.PointAnnotationManager pointAnnotationManager;

  _onMapCreated(mapbox.MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
  }

  @override
  void initState() {
    super.initState();

    _GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<PositionProvider>(
        builder: (context, userPosition, child) {
          geolocator.Position? position = userPosition.position;
          print(position);
          if (position == null) {
            return CircularProgressIndicator();
          }
          return mapbox.MapWidget(
            cameraOptions: mapbox.CameraOptions(
              center: mapbox.Point(
                  coordinates: mapbox.Position(
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
