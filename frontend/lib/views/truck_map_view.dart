import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/truck_model.dart';
import '../models/user_location.dart';
import 'package:provider/provider.dart';
import '../utils/Utils.dart';
import 'dart:async';
import 'package:location/location.dart' as lc;
import 'package:flutter/services.dart';
import 'dart:typed_data';

class FoodTruckMapView extends StatefulWidget {

  Location center;
  Stream<List<TruckModel>> trucksStream;
  FoodTruckMapView(this.center, this.trucksStream);

  @override
  _FoodTruckMapState createState() => _FoodTruckMapState();
}

class _FoodTruckMapState extends State<FoodTruckMapView> {
  GoogleMapController mapController;
  List<Marker> _markers = [];

  StreamSubscription _locationSubscription;
  lc.Location _locationTracker = new lc.Location();
  Marker marker;
  Circle circle;

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load('images/current-location.png');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(lc.LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      _markers.add(Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));
      circle = Circle(
          circleId: CircleId("user"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      //var location = Provider.of<UserLocation>(context);
      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 14.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    widget.trucksStream.asBroadcastStream().listen((trucks) {
        _buildMarkers(trucks);
    });
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _buildMarkers(List<TruckModel> trucks) {
    setState(() {
      // Pretty hacky, need to change later
        List<Marker> markers = [];
        for (final truck in trucks) {
          final marker = Marker(
          markerId: MarkerId(truck.username), 
          position: LatLng(truck.location.lat, truck.location.lng),
          infoWindow: InfoWindow(
            title: truck.displayedName,
            snippet: '${TimeUtils.formatTimestamp(truck.schedule.start)} - ${TimeUtils.formatTimestamp(truck.schedule.end)}',
            ),
          );
          markers.add(marker);
        }
        _markers = markers;
      });
  }

  @override
  Widget build(BuildContext context) {
    LatLng gcenter = LatLng(widget.center.lat, widget.center.lng);
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: gcenter,
            zoom: 13.0,
          ), 
          markers: _markers.toSet(),

          scrollGesturesEnabled: true, 
          zoomGesturesEnabled: true,
          //myLocationEnabled: true,
        ), // GoogleMap
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            getCurrentLocation();
          },
          child: Icon(Icons.my_location),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}