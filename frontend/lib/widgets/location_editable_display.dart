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

  LocationEditableDisplay({this.location, this.onTap, this.locationEditable});

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
              Navigator.of(context).pop();
              onTap(location);
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
      String locationText =  !location.location_name.isEmpty ? location.location_name : "(${location.lat.toStringAsFixed(1)}, ${location.lng.toStringAsFixed(1)})";
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
                  Expanded(child: Text(locationText,
                      style: TextStyle(
                          fontFamily: 'ProximaNovaMedium',
                          fontSize: 16,
                          color: UiColors.bodyText))),
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