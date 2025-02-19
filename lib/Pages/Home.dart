import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:uber_bagare/Pages/FighterProfile.dart';

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

Future<List<dynamic>> getProfilePIctures() async {
  // Construction de l'URL a appeler
  var url = Uri.parse(
      "https://randomuser.me/api/?results=8"); // utilisation de l'api random user pour génerer les information  des utilisateur
  // Appel
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return data['results'];
  } else {
    return [];
  }
}

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                Tab(
                    icon: Icon(
                  Icons.terminal_sharp,
                  size: 50,
                ))
              ],
            ),
            title: Center(
              child: Text("Uber Bagarre"),
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: FutureBuilder(
                    future: getProfilePIctures(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> fighter) {
                      if (fighter.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Text('Please wait its loading...'));
                      } else {
                        if (fighter.hasError) {
                          return Center(
                              child: Text(
                                  'Error: veuiller contacter le support '));
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 30,
                            children: [
                              for (var bagareuer in fighter.data!)
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return FighterPage(user: bagareuer);
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 15,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "${bagareuer['picture']['medium']}"),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              " nom : ${bagareuer['name']['first']}  ${bagareuer['name']['last']}   "),
                                          // crée des valeur fictive
                                          Text(
                                              "${bagareuer['dob']['age'] / 2.toInt()} victoire -- ${bagareuer['dob']['age'] % 2.toInt()} defaite -- ${bagareuer['dob']['age'] / 10.toInt()} KO")
                                        ],
                                      ),
                                      Text("${bagareuer['dob']['age']} km")
                                    ],
                                  ),
                                )
                            ],
                          );
                        }
                      }
                    }),
              ),
              Center(
                child: FutureBuilder<geolocator.Position>(
                  future: _determinePosition(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Please wait its loading...'));
                    } else {
                      //print(snapchot).data;
                      if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error: veuiller contacter le support '));
                      } else {
                        var position = snapshot.data!;
                        mapbox.CameraOptions camera = mapbox.CameraOptions(
                            center: mapbox.Point(
                              coordinates: mapbox.Position(
                                position.longitude,
                                position.latitude,
                              ),
                            ),
                            zoom: 10,
                            bearing: 0,
                            pitch: 0);
                        return mapbox.MapWidget(cameraOptions: camera);
                      }
                    }
                  },
                ),
              )

              //Center(child: Text("${positionActuelle.longitude} km"))
            ],
          ),
        ));
  }
}
