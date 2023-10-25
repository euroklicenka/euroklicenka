import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Represents an EUK location.
class EUKLocationData with ClusterItem {
  late String _id;
  late double _lat;
  late double _lng;
  late String _address;
  late String _region;
  late String _city;
  late String _zip;
  late EUKLocationType _type;
  double distanceFromDevice = 0;
  double distanceFromMap = 0;

  EUKLocationData({
    required String id,
    required double lat,
    required double lng,
    required String address,
    required String region,
    required String city,
    required String zip,
    required EUKLocationType type,
  }) {
    _id = id;
    _lat = lat;
    _lng = lng;
    _address = address;
    _region = region;
    _city = city;
    _zip = zip;
    _type = type;
  }

  EUKLocationData.copy(EUKLocationData data) {
    _id = data.id;
    _lat = data.lat;
    _lng = data.lng;
    _address = data.address;
    _region = data.region;
    _city = data.city;
    _zip = data.zip;
    _type = data.type;
    distanceFromDevice = data.distanceFromDevice;
    distanceFromMap = data.distanceFromMap;
  }

  EUKLocationData.latLng({
    required String id,
    required LatLng latLng,
    required String address,
    required String region,
    required String city,
    required String zip,
    required EUKLocationType type,
  })  : _id = id,
        _lat = latLng.latitude,
        _lng = latLng.longitude,
        _address = address,
        _region = region,
        _city = city,
        _zip = zip,
        _type = type;

  factory EUKLocationData.fromJson(Map<String, dynamic> json) {
    final EUKLocationType type;

    switch (json['type']) {
      case 'wc':
        type = EUKLocationType.wc;
        break;
      case 'platform':
        type = EUKLocationType.platform;
        break;
      case 'gate':
        type = EUKLocationType.gate;
        break;
      case 'elevator':
        type = EUKLocationType.elevator;
        break;
      default:
        throw FormatException("Unknown EUK Location Type ${json['type']}");
    }

    return EUKLocationData(
      id: json['id'].toString(),
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lng'].toString()),
      address: json['address'].toString(),
      region: json['region'].toString(),
      city: json['city'].toString(),
      zip: json['zip'].toString(),
      type: type,
    );
  }

  ///Convert the location data into a JSON format.
  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': lat,
        'lng': lng,
        'address': address,
        'region': region,
        'city': city,
        'ZIP': zip,
        'type': type.index,
      };

  String get id => _id;

  double get lat => _lat;

  double get lng => _lng;

  String get address => _address;

  String get region => _region;

  String get city => _city;

  String get zip => _zip;

  EUKLocationType get type => _type;

  @override
  LatLng get location => LatLng(_lat, _lng);
}

enum EUKLocationType { none, wc, platform, gate, elevator }
