
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestLocationData {
  final double _lat;
  final double _long;
  final String _address;
  final String _city;
  final String _ZIP;
  final EUKLocationType _type;


  TestLocationData(this._lat, this._long, this._address, this._city, this._ZIP, this._type);
  TestLocationData.latLng({required LatLng latLng, required String address, required String city, required String ZIP, required EUKLocationType type}) :
    _lat = latLng.latitude,
    _long = latLng.longitude,
    _address = address,
    _city = city,
    _ZIP = ZIP,
    _type = type;

  double get lat => _lat;
  double get long => _long;
  String get ZIP => _ZIP;
  String get city => _city;
  String get address => _address;
  EUKLocationType get type => _type;

}

enum EUKLocationType {
  none,
  wc,
  platform,
  hospital
}
