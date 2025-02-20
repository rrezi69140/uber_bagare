import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:uber_bagare/Pages/ListFighterView.dart';
import 'package:uber_bagare/Pages/MapView.dart';

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

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.list,
                  size: 50,
                )),
                Tab(
                    icon: Icon(
                  Icons.map_outlined,
                  size: 50,
                )),
              ],
            ),
            title: Center(
              child: Text("Uber Bagarre"),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: ListFighterView()),
              Center(child: MapView())
            ],
          ),
        ));
  }
}
