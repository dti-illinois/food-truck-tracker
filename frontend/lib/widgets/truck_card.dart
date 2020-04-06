import 'package:flutter/material.dart';
import '../models/truck_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utils/Utils.dart';

class TruckCard extends StatefulWidget {
	  TruckModel truck;
	  Location center;
	  GestureTapCallback onCardTap;
	  TruckCard({this.truck, this.center, this.onCardTap});

	  @override
	  TruckCardState createState() => TruckCardState(); 
}

class TruckCardState extends State<TruckCard> {
	bool _isFavorite;
	bool _isFavoriteVisible = false;

	@override
	void initState() {
		_isFavoriteVisible = User().userType == UserType.User;
		_isFavorite = _isFavoriteVisible && User().isFavTruck(widget.truck.username);
		User().addListener(userFavSubscriber);
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

	Widget _buildTags(TruckModel truck) {
  	List<Widget> widgetTags = [];
  	for(String tag in TagHelper.tagsToList(truck.tags)) {
  		if(tag?.isEmpty ?? true) {
  			continue;
  		}
  		widgetTags.add(Container(
  				alignment: Alignment.center,
  				padding: EdgeInsets.symmetric(horizontal: 20),
  				margin: EdgeInsets.only(left: 10, top: 10),
  				height: 30,
  				decoration: BoxDecoration(
  					color: UiColors.darkBlueGrey,
  					borderRadius: BorderRadius.circular(30),
  				), // BoxDecoration
  				child: Text(
  					tag, style: TextStyle(
  					color: UiColors.white
  					), // TextStyle
  				) // Text
  		)); // Container
  	}
  	return Row(crossAxisAlignment: CrossAxisAlignment.center, children: widgetTags);
  }

	 void toggleFavTruck(String truckUsername) {
	  	User().toggleFavTruck(truckUsername);
	  }
	@override
	Widget build(BuildContext context) {
		TruckModel truck = widget.truck;
		double distance = LocationUtils.distance(truck.location.lat, truck.location.lng, widget.center.lat, widget.center.lng); 
	  	String scheduleString = truck.isOpen ? "Is Open, from ${truck.schedule.start} - ${truck.schedule.end}" : "Closed";
	    return Container(
	           padding: EdgeInsets.fromLTRB(10,10,10,10),
	           height: 210,
	           width: double.maxFinite,
	           child: Card(
	             elevation: 5,
	             child: InkWell(
	               onTap: widget.onCardTap,
		           child: Padding(
		             padding: EdgeInsets.only(left: 10, right: 10, top: 10),
		             child: Column(
		                 children: <Widget>[
		                   Row(
		                     children: <Widget>[
		                       Text(truck.displayedName, 
		                       		style: TextStyle(
				                    fontSize: 18,
				                    color: UiColors.darkSlateBlueTwo,
				                    letterSpacing: 1),), 
		                       Visibility(
		                       	visible: _isFavoriteVisible,
		                       	child: GestureDetector(
					              onTap: () {toggleFavTruck(truck.username);},
					              child: Semantics(
				                    label: _isFavorite ? 'Remove From Favorites': 'Add To Favorites',
				                    button: true,
				                    child:Padding(padding: EdgeInsets.all(3), 
				                      child: Image.asset(_isFavorite?'images/icon-star-selected.png':'images/icon-star.png'))) // Semantic
	          					)// GestureDetector
		                       ) // Visibility
		                     ],
		                     mainAxisAlignment: MainAxisAlignment.spaceBetween
		                   ), // Row
		                   Row(
		                     children: <Widget>[
		                        Column(
		                            crossAxisAlignment: CrossAxisAlignment.start,
		                           children: <Widget>[
		                             Text(scheduleString),
		                             Text("${distance.toStringAsFixed(1)} mi away" ),
		                           ], // WidgetList of Column
		                         ),//Column
		                       Image(
		                         image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
		                         fit:BoxFit.scaleDown,
		                         height: 100
		                       ),
		                       
		                     ],// WidgetList of Row
		                     mainAxisAlignment: MainAxisAlignment.spaceBetween
		                   ), 
		                   Divider(height: 2, color: Colors.black87),
		                   _buildTags(truck),
		                 ], // Widget list
		               ), // Column
		           ), // Padding
	           ), // InkWell
	           ), // Card
	        );
	} 
}