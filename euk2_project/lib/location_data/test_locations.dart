import 'package:euk2_project/location_data/test_location_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


/// A list of destinations used for testing
final List<TestLocationData> testDestinations = [
  TestLocationData.latLng(
      latLng: const LatLng(49.8701600, 17.8791761),
      address: 'U železniční stanice',
      city: 'Hradec nad Moravicí',
      ZIP: '747 41',
      type: EUKLocationType.platform),
  TestLocationData.latLng(
      latLng: const LatLng(49.9337922, 17.8793431),
      address: 'Slezská nemocnice Opava',
      city: 'Opava',
      ZIP: '746 01',
      type: EUKLocationType.hospital),
  TestLocationData.latLng(
      latLng: const LatLng(49.8758258, 17.8759750),
      address: 'Státní zámek',
      city: 'Hradec nad Moravicí',
      ZIP: '747 41',
      type: EUKLocationType.platform),
];

