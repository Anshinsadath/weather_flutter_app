import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_flutter/services/location_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  final LocationService _locationService = LocationService();

  Placemark? _currentLocationName;
  Placemark? get currentLocationnName => _currentLocationName;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    print(_currentPosition);

    _currentLocationName = await _locationService.getLocationName(
      _currentPosition,
    );

    print(_currentLocationName);

    notifyListeners();
  }

  // ask the permission

  //get the location

  //get the placemark
}
