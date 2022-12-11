import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
  final String name;
  final LatLng latLng;
  final String address;
  final String region;
  final String city;
  final String ZIP;
  final String info;
  final EUKLocationType type;

  Place( {required this.name, required this.latLng, required this.address, required this.region, required this.info, required this.ZIP, required this.type, required this.city});

  @override
  String toString() {
    return 'Place $name ';
  }

  @override
  LatLng get location => latLng;
}