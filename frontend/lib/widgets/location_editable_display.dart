import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config.dart';
import '../utils/Utils.dart';
import '../secret.dart';
import '../models/truck_model.dart';

typedef LocationPickedCallback = void Function(Location);

class LocationEditableDisplay extends StatelessWidget {
  
  final Location location;
  final LocationPickedCallback onTap;
  final bool locationEditable; 
  final bool locationNameEditable;
  final TextEditingController controller;
  LocationEditableDisplay({this.location, this.onTap, this.locationEditable, this.locationNameEditable=false, this.controller});

  void _onTapEditLocation(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlacePicker(
            apiKey: GOOGLE_MAP_API_KEY,   // Put YOUR OWN KEY here.
            initialPosition: LatLng(LOCATION_LAT, LOCATION_LNG),
            useCurrentLocation: false,
            onPlacePicked: (result) {
              Location location = new Location(lng: result.geometry.location.lng, lat: result.geometry.location.lat, location_name: result.formattedAddress );
              controller.text = result.formattedAddress;
              Navigator.of(context).pop();
              onTap(location);
            },
          ),
        ),
      );
  }

  Widget _locationName() {
    return locationNameEditable ? 
            TextField(controller: controller,
                      style: TextStyle(
                          fontFamily: 'ProximaNovaMedium',
                          fontSize: 16,
                          color: UiColors.bodyText)) : 
            Text(location.location_name??"(${location.lat.toStringAsFixed(1)}, ${location.lng.toStringAsFixed(1)})",
                      style: TextStyle(
                          fontFamily: 'ProximaNovaMedium',
                          fontSize: 16,
                          color: UiColors.bodyText));
  }

  @override
  Widget build(BuildContext context) {
      return Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child:Image.asset('images/icon-location.png'),
                      ),
                      height: 20,
                    ),
                  Expanded(child:_locationName()),
                  Visibility(visible: locationEditable,
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: UiColors.darkSlateBlueTwoTransparent03)
                        ),
                        child: Text("Edit Location"),
                      ),
                      onTap: () => _onTapEditLocation(context),
                    ), // GestureDetector
                  ) // Visibility
                ],
              ), // Row
          ); // Padding
    
  }
}