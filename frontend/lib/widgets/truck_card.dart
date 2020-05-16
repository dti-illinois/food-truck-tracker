import 'package:flutter/material.dart';
import '../models/truck_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utils/Utils.dart';
import 'dart:async';
import 'package:location/location.dart' as lc;
import 'package:flutter/services.dart';
import 'dart:typed_data';

class TruckCard extends StatefulWidget {
	  TruckModel truck;
	  Location center;
	  GestureTapCallback onCardTap;
	  bool isFavoriteVisible;
	  bool isTagsVisible; 
	  TruckCard({this.truck, this.center, this.onCardTap, this.isFavoriteVisible=false, this.isTagsVisible=false});

	  @override
	  TruckCardState createState() => TruckCardState(); 
}

class TruckCardState extends State<TruckCard> {
	bool _isFavorite;
	static const EdgeInsets _iconPadding = EdgeInsets.only(right: 8);
	static const EdgeInsets _detailPadding = EdgeInsets.only(bottom: 8, left: 16, right: 16);
	lc.Location _locationTracker;
	lc.LocationData cur;

	@override
	void initState() {
		_isFavorite = widget.isFavoriteVisible && User().isFavTruck(widget.truck.username);
		User().addListener(userFavSubscriber);
		_locationTracker = new lc.Location();
		getCurrentLocation();
		super.initState();
	}

	@override
	void dispose() {
		User().removeListener(userFavSubscriber);
		super.dispose();
	}

	void userFavSubscriber() {
		this.setState(() {_isFavorite = User().isFavTruck(widget.truck.username);});
	}

	void getCurrentLocation() async {
		cur = await _locationTracker.getLocation();
	}

	Widget _buildTags(TruckModel truck) {
	if(!widget.isTagsVisible) {
		return Container();
	}
  	List<Widget> widgetTags = [];
  	for(String tag in TagHelper.tagsToList(truck.tags)) {
  		if(tag?.isEmpty ?? true) {
  			continue;
  		}
  		widgetTags.add(Container(
  				alignment: Alignment.center,
  				padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
  				margin: EdgeInsets.only(left: 10, top: 10),
  				height: 30,
  				decoration: BoxDecoration(
  					color: UiColors.darkBlueGrey,
  					borderRadius: BorderRadius.circular(30),
  				), // BoxDecoration
  				child: Text(
  					tag, style: TextStyle(
  					color: UiColors.white,
  					fontSize: 14,
  					), // TextStyle
  				) // Text
  		)); // Container
  	}
  	return 
  	widgetTags.length == 0 ? Container() : 
  	Column(children: <Widget>[
			Divider(height: 2, color: Colors.black87),
  			Row(crossAxisAlignment: CrossAxisAlignment.center, children: widgetTags)
  		]);
  }

	 void toggleFavTruck(String truckUsername) {
	  	User().toggleFavTruck(truckUsername);
	  }

	  Widget _truckTitle() {
	  	return Padding(
      		padding: EdgeInsets.only(bottom: 12, left: 16, right: 16),
      		child: Text(widget.truck.displayedName, 
	               		style: TextStyle(
	                    fontSize: 20,
	                    color: UiColors.darkSlateBlueTwo,
	                    fontWeight: FontWeight.bold,
	                    letterSpacing: 1),
	        ), // Text  
      	);
	  }
	  Widget _truckFavIcon() {
	  	return  Visibility(
		                       	visible: widget.isFavoriteVisible,
		                       	child: GestureDetector(
					              onTap: () {toggleFavTruck(widget.truck.username);},
					              child: Semantics(
				                    label: _isFavorite ? 'Remove From Favorites': 'Add To Favorites',
				                    button: true,
				                    child:Padding(padding: EdgeInsets.all(3), 
				                      child: Image.asset(_isFavorite?'images/icon-star-selected.png':'images/icon-star.png'))) // Semantic
	          					)// GestureDetector
		        ); // Visibility
	  }

	  Widget _scheduleDetail() {
	  	TruckModel truck = widget.truck;
	  	String scheduleString = truck.isOpen ? "Is Open, from ${TimeUtils.formatTimeOfDay(truck.schedule.start)} - ${TimeUtils.formatTimeOfDay(truck.schedule.end)}" : "Closed";
	  	return Padding(
		      padding: _detailPadding,
		      child: Row(
		        children: <Widget>[
		        Container(
		        	child:Image.asset('images/icon-time.png'),
		        	height: 20),
		          Padding(
		            padding: _iconPadding,
		          ),
		          Text(scheduleString, overflow: TextOverflow.ellipsis,
		              maxLines: 1,
		              style: TextStyle(
		                  fontFamily: 'ProximaNovaMedium',
		                  fontSize: 14,
		                  color: UiColors.greyishBrown)),
		        ],
		      ),
		    );
	  }

	  Widget _locationDetail() {
	  	TruckModel truck = widget.truck;
	  	double distance = cur != null ? LocationUtils.distance(truck.location.lat, truck.location.lng, cur.latitude, cur.longitude) : -1;
		String distanceString = distance >= 0 ? "${distance.toStringAsFixed(1)} mi away" : ""; 
	  	
	  	return distanceString == "" ? Container() : Padding(
		      padding: _detailPadding,
		      child: Row(
		        children: <Widget>[
		        Container(
		          child: Image.asset('images/icon-location.png'),
		          height: 20,),
		          Padding(
		            padding: _iconPadding,
		          ),
		          Text(distanceString, overflow: TextOverflow.ellipsis,
		              maxLines: 1,
		              style: TextStyle(
		                  fontFamily: 'ProximaNovaMedium',
		                  fontSize: 14,
		                  color: UiColors.greyishBrown)),
		        ],
		      ),
		    );
	  }
	@override
	Widget build(BuildContext context) {
		TruckModel truck = widget.truck;
		
	    return Container(
	           padding: EdgeInsets.fromLTRB(10,10,10,10),
	           width: double.maxFinite,
	           child: Card(
	             elevation: 5,
	             child: InkWell(
	               onTap: widget.onCardTap,
		           child: Column(
		           		children: <Widget>[
		                 	Container(height: 4, color: UiColors.illinoisOrange),
		                 	Padding(
				             padding: EdgeInsets.all(10),
				             child: Column(
				                 children: <Widget>[
				                   Row(
				                     children: <Widget>[
				                       _truckTitle(),
				                       _truckFavIcon(),
				                     ],
				                     mainAxisAlignment: MainAxisAlignment.spaceBetween
				                   ), // Row
				                   Row(
				                     children: <Widget>[
				                        Column(
				                            crossAxisAlignment: CrossAxisAlignment.start,
				                           	children: <Widget>[
				                             _scheduleDetail(),
				                             _locationDetail(),
				                           ], // WidgetList of Column
				                         ),//Column
				                       Image(
				                         image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
				                         fit:BoxFit.scaleDown,
				                         height: 70
				                       ),
				                       
				                     ],// WidgetList of Row
				                     mainAxisAlignment: MainAxisAlignment.spaceBetween
				                   ), 
				                   _buildTags(truck),
				                 ], // Widget list
				               ), // Column
				           ), // Padding
		           		]
		           	), // Column
	           ), // InkWell
	           ), // Card
	        );
	} 
}