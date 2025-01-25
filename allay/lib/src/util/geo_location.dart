import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

final geoLocationProvider = FutureProvider<String>((ref) async {
  List<Placemark> placeMarks = await determinePosition();
  Placemark place = placeMarks[0];
  var label = '${place.subAdministrativeArea}, ${place.administrativeArea}';
  return label;
});

final selectedLocationProvider = StateProvider<AsyncValue<String>>((ref) => ref.watch(geoLocationProvider));

Future<List<Placemark>> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  Position position =  await Geolocator.getCurrentPosition();
  return placemarkFromCoordinates(position.latitude, position.longitude);
}