import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';





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


 //zobrazení aktuální pozice uživatele
  void getLocation() async{
    currentLocation.onLocationChanged.listen((LocationData loc){
      _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));

    });
  }


  MapType _currentMapType = MapType.normal;



  //final Set<Marker> markers = Set();






    //metoda pro zobrazení markers s vlastní ikonou

  /*void  addMarkers() async {
    BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/pin1.png',
    );

    markers.add(Marker(
      //add third marker
      markerId: const MarkerId("Místo 3"),
      position: const LatLng(49.8758258, 17.8759750),
      //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Nemocnice F-M',
        snippet: 'Toalety',
      ),
      //icon: BitmapDescriptor.defaultMarker,
        icon: markerIcon), //Icon for Marker
    );

    markers.add(Marker(
      //add third marker
      markerId: const MarkerId("Místo 1"),
      position: const LatLng(49.9337922, 17.8793431),
      //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Nemocnice F-M',
        snippet: 'Toalety',
      ),
      //icon: BitmapDescriptor.defaultMarker,
       icon: markerIcon), //Icon for Marker
    );

    markers.add(Marker(
      //add third marker
      markerId: const MarkerId("Místo 2"),
      position: LatLng(49.8701600, 17.8791761),
      //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Hypermarket Kaufland',
        snippet: 'WC',
      ),
      //icon: BitmapDescriptor.defaultMarker,
      icon: markerIcon), //Icon for Marker
    );

  }*/


 void getMarkers(){
   markers.add(Marker(
     //add third marker
     markerId: const MarkerId("Místo 3"),
     position: const LatLng(49.8758258, 17.8759750),
     //position of marker
     infoWindow: const InfoWindow(
       //popup info
       title: 'Nemocnice F-M',
       snippet: 'Toalety',
     ),
     icon: BitmapDescriptor.defaultMarker,
     //icon: markerbitmap, //Icon for Marker
   ));



   markers.add(Marker(
     //add third marker
     markerId: const MarkerId("Místo 1"),
     position: const LatLng(49.9337922, 17.8793431),
     //position of marker
     infoWindow: const InfoWindow(
       //popup info
       title: 'Nemocnice F-M',
       snippet: 'Toalety',
     ),
     icon: BitmapDescriptor.defaultMarker,
     // icon: markerbitmap, //Icon for Marker
   ));

   markers.add(Marker(
     //add third marker
     markerId: const MarkerId("Místo 2"),
     position: LatLng(49.8701600, 17.8791761),
     //position of marker
     infoWindow: InfoWindow(
       //popup info
       title: 'Hypermarket Kaufland',
       snippet: 'WC',
     ),
     icon: BitmapDescriptor.defaultMarker,
     //icon: markerbitmap, //Icon for Marker
   ));
 }


  @override
  void initState() {
    //addMarkers();

    setState(() {
      getMarkers();


      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        //zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition:CameraPosition(
          target: LatLng(0.0, 0.0),
          //zoom: 12.0,

        ),
          markers: markers,
        onMapCreated: (GoogleMapController controller){
          _controller = controller;

        }, mapType: _currentMapType,
      ),

    );
  }






}