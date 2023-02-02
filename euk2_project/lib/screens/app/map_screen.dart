import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

///Screen that shows the primary map with EUK locations.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Location _currentLocation = Location();
  LatLng initPosition = const LatLng(50.073658, 14.418540);
  List<String> images = ['assets/images/car.png', 'images/marker.png ,'];

  //zobrazení aktuální pozice uživatele
  Future<void> getLocation() async {
    _currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
            zoom: 10.0,
          ),
        ),
      );
    });
  }

  final MapType _currentMapType = MapType.normal;

  // Widget _drawer() {
  //   return Drawer(
  //     elevation: 16.0,
  //     child: Column(
  //       children: [
  //         //TODO - Replace SizedBox with a more flexible solution
  //         const SizedBox(height: 62),
  //         ColoredBox(
  //           color: Colors.amber,
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
  //             child: Row(
  //               children: [
  //                 const CircleAvatar(
  //                   backgroundImage: NetworkImage(
  //                       'https://play-lh.googleusercontent.com/S0gCtkUxcS1LOC6V2ZqJvVD5lfdTTfSIagePsauBAcLLo-6kGNhoMwgadLRUXyr00jLa=w280-h280',),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 const Text(
  //                   'EuroKlíčenka 2.0',
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.bold,),
  //                 ),
  //                 const Spacer(),
  //                 GestureDetector(
  //                   child: const Icon(Icons.settings, color: Colors.white),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: ListView.separated(
  //             itemCount: context.read<MainScreenBloc>().locationManager.locations.length,
  //             itemBuilder: _buildListTile,
  //             separatorBuilder: (BuildContext context, int index) => const Divider(),
  //             shrinkWrap: true,
  //           ),
  //         )
          
          // ListTile(
          //   onTap: () {
          //     _goToCastle();
          //     Navigator.of(context).pop();
          //
          //     _customInfoWindowController.addInfoWindow!(
          //       EUKPopupWindow(
          //         address: 'Státní zámek',
          //         city: 'Hradec nad Moravicí',
          //         ZIP: '747 41',
          //         imageURL:
          //             'https://www.historickasidla.cz/galerie/obrazky/imager.php?img=542938&x=1000&y=664&hash=6619ef2c0cb8b6992c4e7fd2c699bb43',
          //       ),
          //       const LatLng(49.8758258, 17.8759750),
          //     );
          //   },
          //   title: const Text("Státní zámek"),
          //   subtitle: const Text("Hradec nad Moravicí"),
          //   trailing: getIconByType(EUKLocationType.platform),
          // ),
          // ListTile(
          //   onTap: () {
          //     _goToTrainStation();
          //     Navigator.of(context).pop();
          //     _customInfoWindowController.addInfoWindow!(
          //       EUKPopupWindow(
          //         address: 'Veřejné WC u železniční stanice',
          //         city: 'Hradec nad Moravicí',
          //         ZIP: '747 41',
          //         imageURL:
          //             'https://g.denik.cz/74/9d/op-hradec-nad-moravici-toalety0205_denik-630-16x9.jpg',
          //       ),
          //       const LatLng(49.8701600, 17.8791761),
          //     );
          //   },
          //   title: const Text("Veřejné WC u železniční stanice"),
          //   subtitle: const Text("Hradec nad Moravicí"),
          //   trailing: getIconByType(EUKLocationType.wc),
          // ),
          //
          // ListTile(
          //   onTap: () {
          //     _goToHospital();
          //     Navigator.of(context).pop();
          //     _customInfoWindowController.addInfoWindow!(
          //       EUKPopupWindow(
          //         address: 'Slezská nemocnice Opava',
          //         city: 'Opava',
          //         ZIP: '746 01',
          //         imageURL:
          //             'http://polar.cz/data/gallery/modules/polar/news/articles/videos/20200319151335_301/715x402.jpg?ver=20200319151525',
          //       ),
          //       const LatLng(49.9337922, 17.8793431),
          //     );
          //   },
          //   title: const Text("Slezská nemocnice Opava"),
          //   subtitle: const Text('Opava'),
          //   trailing: getIconByType(EUKLocationType.hospital),
          // ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _goToTrainStation() async {
  //   _controller?.animateCamera(
  //     CameraUpdate.newLatLngZoom(const LatLng(49.8701600, 17.8791761), _zoom),
  //   );
  // }
  //
  // Future<void> _goToCastle() async {
  //   _controller?.animateCamera(
  //     CameraUpdate.newLatLngZoom(const LatLng(49.8758258, 17.8759750), _zoom),
  //   );
  // }
  //
  // Future<void> _goToHospital() async {
  //   _controller?.animateCamera(
  //     CameraUpdate.newLatLngZoom(const LatLng(49.9337922, 17.8793431), _zoom),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              context.read<LocationManagementBloc>().locationManager.windowController.googleMapController = controller;
            },
            onTap: (position) => context.read<LocationManagementBloc>().locationManager.windowController.hideInfoWindow!(),
            onCameraMove: (position) => context.read<LocationManagementBloc>().locationManager.windowController.onCameraMove!(),
            mapType: _currentMapType,
            markers: context.watch<LocationManagementBloc>().locationManager.markers,
            initialCameraPosition: const CameraPosition(
              //target: LatLng(0.0, 0.0),
              target: LatLng(50.073658, 14.418540),
              zoom: 6.0,
            ),
          ),
          CustomInfoWindow(
            controller: context.watch<LocationManagementBloc>().locationManager.windowController,
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width * 0.8,
            offset: 70,
          ),
        ],
      );
  }
}

///The AppBar for the Map Screen.
class AppBarMapScreen extends StatelessWidget {
  const AppBarMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Mapa míst'),
      centerTitle: true,
    );
  }
}

