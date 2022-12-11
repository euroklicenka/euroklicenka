import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/features/icon_management/icon_manager.dart';
import 'package:euk2_project/features/location_data/data/euk_location_data.dart';
import 'package:euk2_project/features/popup_window/popup_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

///Represents a map marker of an EUK location.
///
/// Is a child of the Google Maps [Marker].
class EUKMarker extends Marker {
  final EUKLocationData data;

  EUKMarker._create({required super.markerId, required this.data, required super.icon, required super.onTap}) : super(
          position: LatLng(data.lat, data.long),
        );


  ///Creates a new [EUKMarker] instance asynchronously.
  static Future<EUKMarker> create({required String id, required EUKLocationData data, required CustomInfoWindowController windowController}) async {
    final BitmapDescriptor icon = await getMarkerIconByType(data.type);
    final EUKMarker m = EUKMarker._create(
        markerId: MarkerId(id),
        data: data,
        icon: icon,
        onTap: (){
          windowController.addInfoWindow!(
            EUKPopupWindow(
              address: data.address,
              region: data.region,
              city: data.city,
              info: data.info,
              ZIP: data.ZIP,
              imageURL:
                  //TODO Replace or Remove once we know how we are going to put in pictures.
              'http://polar.cz/data/gallery/modules/polar/news/articles/videos/20200319151335_301/715x402.jpg?ver=20200319151525',
            ),
            LatLng(data.lat, data.long),
          );
        },
    );

    return m;
  }
}
