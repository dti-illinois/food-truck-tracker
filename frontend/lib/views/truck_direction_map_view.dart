import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/truck_model.dart';
import '../utils/Utils.dart';
import '../secret.dart';
import 'package:location/location.dart' as lc;

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class MapDirectionViewArguments {
	//Location curLocation;
	Location targetLocation;
	MapDirectionViewArguments({this.targetLocation});
}

class MapDirectionView extends StatefulWidget {
	static String id = "truck_direction";

	//Location curLocation;
	Location targetLocation;

	//MapDirectionView({this.curLocation, this.targetLocation});
  MapDirectionView({this.targetLocation});

	@override
	State<StatefulWidget> createState() => MapDirectionState();
}

class MapDirectionState extends State<MapDirectionView> {

  StreamSubscription _locationSubscription;
  LocationData curLocation;
  lc.Location _locationTracker;

	Completer<GoogleMapController> _controller = Completer();
	// this set will hold my markers
	Set<Marker> _markers = {};
	// this will hold the generated polylines
	Set<Polyline> _polylines = {};
	// this will hold each polyline coordinate as Lat and Lng pairs
	List<LatLng> polylineCoordinates = [];
	// generates every polyline between start and finish
	PolylinePoints polylinePoints = PolylinePoints(); 

	BitmapDescriptor sourceIcon;
	BitmapDescriptor destinationIcon;
	LatLng _sourceLocation;
	LatLng _destLocation;


	@override 
	void initState() {
		super.initState();
		//initialize current location
    _locationTracker = new lc.Location();
    _locationTracker.onLocationChanged().listen((LocationData cLoc) {

      _sourceLocation = LatLng(cLoc.latitude, cLoc.longitude);;
      updatePinOnMap();
    });

    _setSourceAndDestinationIcons();
		//_sourceLocation = LatLng(curLocation.latitude, curLocation.longitude);
    curLocation = await _locationTracker.getLocation();
    _sourceLocation = LatLng(curLocation.latitude, curLocation.longitude);
		//_sourceLocation = LatLng(widget.curLocation.lat, widget.curLocation.lng);
		_destLocation = LatLng(widget.targetLocation.lat,  widget.targetLocation.lng);
	}

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(_sourceLocation.latitude,
          _sourceLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      // updated position
      var pinPosition = LatLng(_sourceLocation.latitude,
          _sourceLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon
      ));
    });
  }


      void _setSourceAndDestinationIcons() async {
		AssetUtils.getBytesFromAsset('images/current-location.png', 100)
	      			.then((bytes) {
	      					sourceIcon = BitmapDescriptor.fromBytes(bytes);
	      				});
		AssetUtils.getBytesFromAsset('images/marker.png', 100)
					.then((bytes) {
							destinationIcon = BitmapDescriptor.fromBytes(bytes);
						});
	}

	void onMapCreated(GoogleMapController controller) {
	   _controller.complete(controller);
	   setMapPins();
	   setPolylines();
	}

	void setMapPins() {
		setState(() {
		      // source pin
			_markers.add(Marker(
				markerId: MarkerId('sourcePin'),
				position: _sourceLocation,
				icon: sourceIcon
			));
			// destination pin
			_markers.add(Marker(
				markerId: MarkerId('destPin'),
				position: _destLocation,
				icon: destinationIcon
			));
		});
	}

	setPolylines() async {
		await
		  polylinePoints?.getRouteBetweenCoordinates(
					GOOGLE_MAP_API_KEY,
		     _sourceLocation.latitude,
		     _sourceLocation.longitude,
		     _destLocation.latitude,
		     _destLocation.longitude)
		  .then((result) {
				if(result.isNotEmpty){
				  // loop through all PointLatLng points and convert them
				  // to a list of LatLng, required by the Polyline
				  result.forEach((PointLatLng point){
				     polylineCoordinates.add(
				        LatLng(point.latitude, point.longitude));
				  });
				}
		  	});
		  		
		setState(() {
		  // create a Polyline instance
		  // with an id, an RGB color and the list of LatLng pairs
		  Polyline polyline = Polyline(
		     polylineId: PolylineId("poly"),
		     color: Color.fromARGB(255, 40, 122, 198),
		     points: polylineCoordinates
		  );

		  // add the constructed polyline as a set of points
		  // to the polyline set, which will eventually
		  // end up showing up on the map
		  _polylines.add(polyline);
		});
	}

	@override
	Widget build(BuildContext context) {
	   CameraPosition initialLocation = CameraPosition(
	      zoom: CAMERA_ZOOM,
	      bearing: CAMERA_BEARING,
	      tilt: CAMERA_TILT,
	      target: _sourceLocation
	   );

	   return GoogleMap(
	      myLocationEnabled: true,
	      compassEnabled: true,
	      tiltGesturesEnabled: false,
	      markers: _markers,
	      polylines: _polylines,
	      mapType: MapType.normal,
	      initialCameraPosition: initialLocation,
	      onMapCreated: onMapCreated
	   );
	}
}