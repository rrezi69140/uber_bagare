

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart' as GEOLOCATOR;

import '../model/position_model.dart' as ModelPosition;

class PositionProvider extends ChangeNotifier {
  GEOLOCATOR.Position? position;

  GEOLOCATOR.Position? get userPosition => position;

  PositionProvider() {
    getLocalisation();
  }

  void getLocalisation() async {
    position = await ModelPosition.determinePosition();
    notifyListeners();
  }
}
