import 'package:google_maps_flutter/google_maps_flutter.dart';

///Represents an EUK location.
class EUKLocationData {
  final String _id;
  final double _lat;
  final double _long;
  final String _address;
  final String _region;
  final String _city;
  final String _ZIP;
  final String _info;
  final EUKLocationType _type;

  EUKLocationData(this._id, this._lat, this._long, this._address, this._region,
      this._city, this._info, this._ZIP, this._type);

  EUKLocationData.latLng({
    required String id,
    required LatLng latLng,
    required String address,
    required String region,
    required String city,
    required String info,
    required String ZIP,
    required EUKLocationType type,
  })  : _id = id,
        _lat = latLng.latitude,
        _long = latLng.longitude,
        _address = address,
        _region = region,
        _city = city,
        _info = info,
        _ZIP = ZIP,
        _type = type;


  String get id => _id;

  double get lat => _lat;

  double get long => _long;

  String get address => _address;

  String get region => _region;

  String get city => _city;

  String get info => _info;

  String get ZIP => _ZIP;

  EUKLocationType get type => _type;
}

enum EUKLocationType { none, wc, platform, hospital, office }
