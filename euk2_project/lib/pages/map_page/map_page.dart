import 'package:custom_info_window/custom_info_window.dart';
import 'package:euk2_project/location_data/test_location_data.dart';
import 'package:euk2_project/pages/map_page/popup_window/popup_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../location_data/test_locations.dart';

///AppBar of the More Screen.

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> markers = {};
  final double _zoom = 15;
  List<String> images = ['assets/images/car.png', 'images/marker.png ,'];
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();


  //zobrazení aktuální pozice uživatele
  Future<void> getLocation() async {
    currentLocation.onLocationChanged.listen((LocationData loc) {
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

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void getMarkers() {
    for (int i = 0; i < images.length; i++) {
      print('name${images[i]}');

      if (i == 1) {
        markers.add(
          Marker(
            markerId: const MarkerId('2'),
            position: const LatLng(49.8701600, 17.8791761),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                MarkerPopupWindow(
                  address: 'U železniční stanice',
                  city: 'Hradec nad Moravicí',
                  ZIP: '747 41',
                  imageURL:
                  'https://g.denik.cz/74/9d/op-hradec-nad-moravici-toalety0205_denik-630-16x9.jpg',
                ),
                const LatLng(49.8701600, 17.8791761),
              );
            },
          ),
        );
      } else {
        markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: const LatLng(49.9337922, 17.8793431),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                MarkerPopupWindow(
                  address: 'Slezská nemocnice Opava',
                  city: 'Opava',
                  ZIP: '746 01',
                  imageURL:
                  'http://polar.cz/data/gallery/modules/polar/news/articles/videos/20200319151335_301/715x402.jpg?ver=20200319151525',
                ),
                const LatLng(49.9337922, 17.8793431),
              );
            },
          ),
        );
        markers.add(
          Marker(
            markerId: const MarkerId("3"),
            position: const LatLng(49.8758258, 17.8759750),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                MarkerPopupWindow(
                  address: 'Státní zámek',
                  city: 'Hradec nad Moravicí',
                  ZIP: '747 41',
                  imageURL:
                  'https://www.historickasidla.cz/galerie/obrazky/imager.php?img=542938&x=1000&y=664&hash=6619ef2c0cb8b6992c4e7fd2c699bb43',
                ),
                const LatLng(49.8758258, 17.8759750),
              );
            },
          ),
        );
      }
      setState(() {});
    }
  }


  @override
  void initState() {
    //addMarkers();

    setState(() {
      getMarkers();
      //getLocation();
    });
  }

  Widget _drawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          //TODO - Replace SizedBox with a more flexible solution
          const SizedBox(height: 62,),
          ColoredBox(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://play-lh.googleusercontent.com/S0gCtkUxcS1LOC6V2ZqJvVD5lfdTTfSIagePsauBAcLLo-6kGNhoMwgadLRUXyr00jLa=w280-h280'),
                  ),
                  const SizedBox(width: 10,),
                  const Text('EuroKlíčenka 2.0', style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.bold),),
                  const Spacer(),
                  GestureDetector(
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),

                ],
              ),
            ),
          ),


          const ListTile(
            title: Text("Seznam míst"),
            leading: Icon(Icons.place, color: Colors.black,),
            // tileColor: Colors.amber,
            textColor: Colors.black,
          ),
          const Divider(),
          ListTile(
            onTap: () {
              _goToNewYork();
              Navigator.of(context).pop();
            },
            title: const Text("Opava - Kateřinky"),
            subtitle: const Text("Hypermarket Kaufland, Hlučínská 1698/5"),
            trailing: getIconByType(EUKLocationType.platform),
          ),
          ListTile(
            onTap: () {
              _goToLondon();
              Navigator.of(context).pop();
            },
            title: const Text("Státní zámek"),
            subtitle: const Text("Hradec nad Moravicí"),
            trailing: getIconByType(EUKLocationType.platform),
          ),
          ListTile(
            onTap: () {
              _goToTokyo();
              Navigator.of(context).pop();
            },
            title: const Text("U železniční stanice"),
            subtitle: const Text("Hradec nad Moravicí"),
            trailing: getIconByType(EUKLocationType.platform),
          ),
          ListTile(
            onTap: () {
              _goToDubai();
              Navigator.of(context).pop();
            },
            title: const Text("Slezská nemocnice Opava"),
            subtitle: const Text('Opava'),
            trailing: getIconByType(EUKLocationType.hospital),
          ),
        ],
      ),
    );
  }

  Future<void> _goToNewYork() async {
    _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(const LatLng(49.8758258, 17.8759750), _zoom),
    );
    setState(() {
      //markers.clear();
      markers.add(
        const Marker(
          markerId: MarkerId('Opava Kateřinky'),
          position: LatLng(49.9463158, 17.9287797),
          //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Opava Kateřinky', snippet: 'WC'),
        ),
      );
    });
  }

  Future<void> _goToLondon() async {
    //final GoogleMapController controller = await _controller.future;
    _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(const LatLng(49.8758258, 17.8759750), _zoom),
    );
    setState(() {
      //markers.clear();
      markers.add(
        const Marker(
          markerId: MarkerId('hradec'),
          position: LatLng(49.8701600, 17.8791761),
          //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Hradec nad Moravicí',
            snippet: 'Státní zámek ',
          ),
        ),
      );
    });
  }

  Future<void> _goToTokyo() async {
    _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(const LatLng(49.9337922, 17.8793431), _zoom),
    );
    setState(() {
      markers.add(
        const Marker(
          markerId: MarkerId('hradec2'),
          position: LatLng(49.8758258, 17.8759750),
          infoWindow: InfoWindow(
            title: 'Hradec nad Moravicí',
            snippet: 'Železniční stanice',
          ),
        ),
      );
    });
  }

  Future<void> _goToDubai() async {
    _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(const LatLng(49.8701600, 17.8791761), _zoom),
    );
    setState(() {
      //markers.clear();
      markers.add(
        const Marker(
          markerId: MarkerId('opava_nemocnice'),
          position: LatLng(49.9337922, 17.8793431),
          infoWindow: InfoWindow(
            title: 'Slezská nemocnice Opava',
            snippet: 'wc, přízemí',
          ),
        ),
      );
    });
  }

  Future<void> _goToParis() async {
    const double lat = 48.8566;
    const double long = 2.3522;
    _controller
        ?.animateCamera(CameraUpdate.newLatLngZoom(const LatLng(lat, long), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        const Marker(
          markerId: MarkerId('paris'),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(title: 'Paris', snippet: 'Welcome to Paris'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // loadData() ;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa míst'),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _customInfoWindowController.googleMapController = controller;
            },
            mapType: _currentMapType,
            markers: markers,
            initialCameraPosition: const CameraPosition(
              //target: LatLng(0.0, 0.0),
              target: LatLng(50.073658, 14.418540),
              zoom: 6.0,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 300,
            offset: 35,
          ),
        ],
      ),
    );
  }
}
