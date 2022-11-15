
import 'dart:typed_data';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';



///AppBar of the More Screen.
AppBar? mapAppBar;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  Location currentLocation = Location();
  Set<Marker> markers = Set();
  final double _zoom = 15;
  List<String> images = ['assets/images/car.png', 'images/marker.png ,'];
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  Uint8List? markerImage;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  //zobrazení aktuální pozice uživatele
  void getLocation() async {
    currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller?.animateCamera(
          CameraUpdate.newCameraPosition(new CameraPosition(
            target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
            zoom: 10.0,
          )));
    });
  }


  MapType _currentMapType = MapType.normal;


  //final Set<Marker> markers = Set();


  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }


  void getMarkers() {
    for (int i = 0; i < images.length; i++) {
      print('name' + images[i].toString());

      if (i == 1) {
        markers.add(Marker(
            markerId: MarkerId('2'),
            position: LatLng(49.8701600, 17.8791761),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://g.denik.cz/74/9d/op-hradec-nad-moravici-toalety0205_denik-630-16x9.jpg'),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                ' Veřejné WC ',
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Hradec nad Moravicí',
                              // widget.data!.date!,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          'U železniční stanice',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                LatLng(49.8701600, 17.8791761),
              );
            }));
      } else {
        markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(49.9337922, 17.8793431),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'http://polar.cz/data/gallery/modules/polar/news/articles/videos/20200319151335_301/715x402.jpg?ver=20200319151525'),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Slezská nemocnice Opava',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'telefon: 666666666',
                              // widget.data!.date!,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          'wc, přízemí',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                LatLng(49.9337922, 17.8793431),
              );
            }));
        markers.add(Marker(
            markerId: MarkerId("3"),
            position: LatLng(49.8758258, 17.8759750),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://www.historickasidla.cz/galerie/obrazky/imager.php?img=542938&x=1000&y=664&hash=6619ef2c0cb8b6992c4e7fd2c699bb43'),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Státní zámek ',
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Hradec nad Moravicí',
                              // widget.data!.date!,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          ' Městečko 2 (Červený zamek, Bílý zámek)',
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                LatLng(49.8758258, 17.8759750),
              );
            }));
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

          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('https://play-lh.googleusercontent.com/S0gCtkUxcS1LOC6V2ZqJvVD5lfdTTfSIagePsauBAcLLo-6kGNhoMwgadLRUXyr00jLa=w280-h280'),
                  radius: 40.0,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Euroklíčenka',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25.0
                      ),
                    ),
                    SizedBox(height: 10.0),
                    //Text('Přírodovědecká fakulta OU',
                    //style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    //color: Colors.white,
                    //fontSize: 14.0
                    //),
                    //),
                  ],
                )
              ],
            ),
          ),

          ListTile(
            title: new Text("Seznam míst"),
            leading: new Icon(Icons.place),
          ),
          Divider(),
          ListTile(
            onTap: () {
              _goToNewYork();
              Navigator.of(context).pop();
            },
            title: new Text("Opava - Kateřinky"),
            subtitle: new Text("Hypermarket Kaufland, Hlučínská 1698/5"),
            trailing: new Icon(Icons.accessible),
          ),
          ListTile(
            onTap: () {
              _goToNewDelhi();
              Navigator.of(context).pop();
            },
            title: new Text("Opava - Předměstí"),
            subtitle: new Text(
                "Hypermarket Kaufland, Olomoucká 2995, 746 01 Opava - Předměstí"),
          ),
          ListTile(
            onTap: () {
              _goToLondon();
              Navigator.of(context).pop();
            },
            title: new Text("Hradec nad Moravicí"),
            subtitle: new Text(
                "Státní zámek "),

            trailing: new Icon(Icons.accessible),
          ),
          ListTile(
            onTap: () {
              _goToTokyo();
              Navigator.of(context).pop();
            },
            title: new Text("Hradec nad Moravicí"),
            subtitle: new Text(
                "U železniční stanice"),
            trailing: new Icon(Icons.accessible),
          ),
          ListTile(
            onTap: () {
              _goToDubai();
              Navigator.of(context).pop();
            },
            title: new Text("Slezská nemocnice Opava"),
            trailing: new Icon(Icons.accessible),
          ),
          ListTile(
            onTap: () {
              _goToParis();
              Navigator.of(context).pop();
            },
            title: new Text("Paris"),
            subtitle: new Text("data"),
            trailing: new Icon(Icons.accessible),
          )
        ],
      ),
    );
  }


  Future<void> _goToNewYork() async {
    _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(49.8758258, 17.8759750), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId('Opava Kateřinky'),
            position: const LatLng(49.9463158, 17.9287797),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: 'Opava Kateřinky', snippet: 'WC')
        ),
      );
    });
  }

  Future<void> _goToNewDelhi() async {
    _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(49.9304661, 17.8747525), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId('Opava Předměstí'),
            position: LatLng(49.9304661, 17.8747525),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: 'Opava Předměstí', snippet: 'WC')),
      );
    });
  }

  Future<void> _goToLondon() async {
    //final GoogleMapController controller = await _controller.future;
    _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(49.8758258, 17.8759750), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId('hradec'),
            position: LatLng(49.8701600, 17.8791761),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
                title: 'Hradec nad Moravicí', snippet: 'Státní zámek ')),

      );
    });
  }

  Future<void> _goToTokyo() async {
    //final GoogleMapController controller = await _controller.future;
    _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(49.9337922, 17.8793431), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId('hradec2'),
            position: LatLng(49.8758258, 17.8759750),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
                title: 'Hradec nad Moravicí', snippet: 'Železniční stanice')),
      );
    });
  }

  Future<void> _goToDubai() async {
    //final GoogleMapController controller = await _controller.future;
    _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(49.8701600, 17.8791761), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId('opava_nemocnice'),
            position: LatLng(49.9337922, 17.8793431),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
                title: 'Slezská nemocnice Opava', snippet: 'wc, přízemí')),
      );
    });
  }

  Future<void> _goToParis() async {
    double lat = 48.8566;
    double long = 2.3522;
    //final GoogleMapController controller = await _controller.future;
    _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
    setState(() {
      //markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId('paris'),
            position: LatLng(lat, long),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
                title: 'Paris', snippet: 'Welcome to Paris')),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    // loadData() ;
    return Scaffold(
      appBar: AppBar(
        title: Text('Euroklíčenka'),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller){
              _controller = controller;
              _customInfoWindowController.googleMapController = controller;



            }, mapType: _currentMapType,

            markers: markers,
            initialCameraPosition:CameraPosition(
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
















