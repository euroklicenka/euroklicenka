import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

int _idCounter = 0;

/// A list of destinations used for testing
final List<EUKLocationData> testLocations = [
  EUKLocationData.latLng(
      id: '0',
      latLng: const LatLng(49.8701600, 17.8791761),
      address: 'U železniční stanice',
      region: '',
      city: 'Hradec nad Moravicí',
      info: '',
      ZIP: '747 41',
      type: EUKLocationType.platform,),
  EUKLocationData.latLng(
      id: '1',
      latLng: const LatLng(49.9337922, 17.8793431),
      address: 'Slezská nemocnice Opava',
      region: '',
      city: 'Opava',
      info: '',
      ZIP: '746 01',
      type: EUKLocationType.hospital,),
  EUKLocationData.latLng(
      id: '2',
      latLng: const LatLng(49.8758258, 17.8759750),
      address: 'Státní zámek',
      region: '',
      city: 'Hradec nad Moravicí',
      info: '',
      ZIP: '747 41',
      type: EUKLocationType.wc,),
  EUKLocationData.latLng(
      id: '3',
      latLng: const LatLng(49.8, 17.87),
      address: 'Clam - Gallasův palác, Husova 158/20, 110 00 Praha 1',
      region: 'Hlavní město Praha',
      city: 'Praha 1',
      info: 'přízemí',
      ZIP: '110 00',
      type: EUKLocationType.wc,),
];

int getID() {
  final int id = _idCounter;
  _idCounter = _idCounter++;
  return id;
}