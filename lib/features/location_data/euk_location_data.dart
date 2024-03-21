// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

///Represents an EUK location.
class EUKLocationData {
  late String _id;
  late double _lat;
  late double _lng;
  late String _place;
  late String _street;
  late String _region;
  late String _city;
  late String _zip;
  late EUKLocationType _type;
  double distanceFromUser = 0;
  double distanceFromMap = 0;

  EUKLocationData({
    required String id,
    required double lat,
    required double lng,
    required String place,
    required String street,
    required String region,
    required String city,
    required String zip,
    required EUKLocationType type,
  }) {
    _id = id;
    _lat = lat;
    _lng = lng;
    _place = place;
    _street = street;
    _region = region;
    _city = city;
    _zip = zip;
    _type = type;
  }

  EUKLocationData.copy(EUKLocationData data) {
    _id = data.id;
    _lat = data.lat;
    _lng = data.lng;
    _place = data.place;
    _street = data.street;
    _region = data.region;
    _city = data.city;
    _zip = data.zip;
    _type = data.type;
    distanceFromUser = data.distanceFromUser;
    distanceFromMap = data.distanceFromMap;
  }

  EUKLocationData.latLng({
    required String id,
    required LatLng latLng,
    required String place,
    required String street,
    required String region,
    required String city,
    required String zip,
    required EUKLocationType type,
  })  : _id = id,
        _lat = latLng.latitude,
        _lng = latLng.longitude,
        _place = place,
        _street = street,
        _region = region,
        _city = city,
        _zip = zip,
        _type = type;

  factory EUKLocationData.fromJson(Map<String, dynamic> json) {
    final EUKLocationType type;

    switch (json['type']) {
      case 'wc':
        type = EUKLocationType.wc;
      case 'platform':
        type = EUKLocationType.platform;
      case 'gate':
        type = EUKLocationType.gate;
      case 'elevator':
        type = EUKLocationType.elevator;
      default:
        throw FormatException("Unknown EUK Location Type ${json['type']}");
    }

    return EUKLocationData(
      id: json['id'].toString(),
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lng'].toString()),
      place: json['place'].toString(),
      street: json['street'].toString(),
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
        'place': place,
        'street': street,
        'region': region,
        'city': city,
        'ZIP': zip,
        'type': type.index,
      };

  Marker toMarker(EurolockProvider eukProvider) {
    return Marker(
      point: LatLng(lat, lng),
      child: GestureDetector(
        onTap: () => eukProvider.currentEUK = this,
        child: getMarkerIconByType(type),
      ),
      rotate: true,
    );
  }

  String get id => _id;

  double get lat => _lat;

  double get lng => _lng;

  String get place => _place;

  String get street => _street;

  String get region => _region;

  String get city => _city;

  String get zip => _zip;

  EUKLocationType get type => _type;

  LatLng get location => LatLng(_lat, _lng);
}

enum EUKLocationType { none, wc, platform, gate, elevator }
