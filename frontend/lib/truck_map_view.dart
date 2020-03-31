import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'truck_model.dart';

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
            snippet: '${truck.schedule.toString()}',
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
          zoomGesturesEnabled: true,
          markers: _markers.toSet(),
        ), // GoogleMap
      ),
    );
  }
}