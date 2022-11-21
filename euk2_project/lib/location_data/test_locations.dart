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

Icon getIconByType(EUKLocationType type) {
  switch (type) {
    case EUKLocationType.wc:
      return const Icon(
        Icons.wc,
        color: Colors.blue,
        size: 28,
      );
    case EUKLocationType.platform:
      return const Icon(
        Icons.accessible_sharp,
        color: Colors.red,
        size: 28,
      );
    case EUKLocationType.hospital:
      return const Icon(
        Icons.local_hospital,
        color: Colors.green,
        size: 28,
      );
  }
}
