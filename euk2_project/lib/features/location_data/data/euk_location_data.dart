import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Represents an EUK location.
 class EUKLocationData with ClusterItem {
  late String _id;
  late double _lat;
  late double _long;
  late String _address;
  late String _region;
  late String _city;
  late String _ZIP;
  late String _info;
  late EUKLocationType _type;

  EUKLocationData(
      {required String id, required double lat, required double long, required String address, required String region, required String city,
        required String ZIP, required String info, required EUKLocationType type}) {
    _id = id;
    _lat = lat;
    _long = long;
    _address = address;
    _region = region;
    _city = city;
    _ZIP = ZIP;
    _info = info;
    _type = type;
  }

  EUKLocationData.copy(EUKLocationData data) {
    _id = data.id;
    _lat = data.lat;
    _long = data.long;
    _address = data.address;
    _region = data.region;
    _city = data.city;
    _ZIP = data.ZIP;
    _info = data.info;
    _type = data.type;
  }

  EUKLocationData.latLng({
    required String id,
    required LatLng latLng,
    required String address,
    required String region,
    required String city,
    required String info,
    required String ZIP,
    required EUKLocationType type,
  })
      : _id = id,
        _lat = latLng.latitude,
        _long = latLng.longitude,
        _address = address,
        _region = region,
        _city = city,
        _info = info,
        _ZIP = ZIP,
        _type = type;

  factory EUKLocationData.fromJson(Map<String, dynamic> json) {
    return EUKLocationData(
        id: json['id'].toString(),
        lat: double.parse(json['lat'].toString()),
        long: double.parse(json['long'].toString()),
        address: json['address'].toString(),
        region: json['region'].toString(),
        city: json['city'].toString(),
        ZIP: json['ZIP'].toString(),
        info: json['info'].toString(),
        type: EUKLocationType.values[int.parse(json['type'].toString())],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': lat,
        'long': long,
        'address': address,
        'region': region,
        'city': city,
        'ZIP': ZIP,
        'info': info,
        'type': type.index,
      };

  String get id => _id;

  double get lat => _lat;

  double get long => _long;

  String get address => _address;

  String get region => _region;

  String get city => _city;

  String get info => _info;

  String get ZIP => _ZIP;

  EUKLocationType get type => _type;

  @override
  LatLng get location => LatLng(_lat, _long);
}

enum EUKLocationType { none, wc, platform, hospital, gate, elevator }
