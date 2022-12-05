import 'package:euk2_project/location_data/data/euk_location_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

int _idCounter = 0;

/// A list of destinations used for testing
final List<EUKLocationData> testLocations = [
  EUKLocationData.latLng(
      id: _idCounter.toString(),
      latLng: const LatLng(49.8701600, 17.8791761),
      address: 'U železniční stanice',
      region: '',
      city: 'Hradec nad Moravicí',
      info: '',
      ZIP: '747 41',
      type: EUKLocationType.platform),
  EUKLocationData.latLng(
      id: _idCounter.toString(),
      latLng: const LatLng(49.9337922, 17.8793431),
      address: 'Slezská nemocnice Opava',
      region: '',
      city: 'Opava',
      info: '',
      ZIP: '746 01',
      type: EUKLocationType.hospital),
  EUKLocationData.latLng(
      id: _idCounter.toString(),
      latLng: const LatLng(49.8758258, 17.8759750),
      address: 'Státní zámek',
      region: '',
      city: 'Hradec nad Moravicí',
      info: '',
      ZIP: '747 41',
      type: EUKLocationType.wc),
];

int getID() {
  final int id = _idCounter;
  _idCounter = _idCounter++;
  return id;
}