import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'truck_model.dart';

class FoodTruckMapView extends StatefulWidget {

  Location center;
  List<TruckModel> data;
  FoodTruckMapView(this.center, this.data);

  @override
  _FoodTruckMapState createState() => _FoodTruckMapState();
}

class _FoodTruckMapState extends State<FoodTruckMapView> {
  GoogleMapController mapController;
  List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _buildMarkers();
  }

  void _buildMarkers() {
    setState(() {
        for (final truck in widget.data) {
          print('${truck.location.lat}  ${truck.location.lng}');
          final marker = Marker(
          markerId: MarkerId(truck.username), 
          position: LatLng(truck.location.lat, truck.location.lng),
          infoWindow: InfoWindow(
            title: truck.displayedName,
            snippet: '${truck.schedule.toString()}',
            ),
          );
          _markers.add(marker);
        }
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