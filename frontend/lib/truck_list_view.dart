import 'package:flutter/material.dart';
import 'truck_model.dart';
import 'truck_service.dart';
import 'utils/Utils.dart';
import 'user_model.dart';

class FoodTruckListView extends StatefulWidget {
  static String id = "foodtrucklistview";
  List<TruckModel> trucks;
  Location center;
  FoodTruckListView(this.trucks, this.center);

  @override
  TruckListState createState() => TruckListState(); 
}

class TruckListState extends State<FoodTruckListView> {

  bool _isListLoading = false; 

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTruckLists() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.transparent,
      ),
      itemBuilder: (context, i) {
        return _buildTruckCard(widget.trucks[i]);
      },
      itemCount: widget.trucks.length,
    );
  }

  void _onCardTap(TruckModel truck) {
  	Navigator.pushNamed(context, 'truck_detail', arguments: truck);
  }

  Widget _buildTags(TruckModel truck) {
  	List<Widget> widgetTags = [];
  	for(String tag in TagHelper.tagsToList(truck.tags)) {
  		if(tag?.isEmpty ?? true) {
  			continue;
  		}
  		print("tag: " + tag);
  		widgetTags.add(Container(
  				alignment: Alignment.center,
  				padding: EdgeInsets.symmetric(horizontal: 20),
  				margin: EdgeInsets.only(left: 10),
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

  Widget _buildTruckCard(TruckModel truck) {
  	double distance = LocationUtils.distance(truck.location.lat, truck.location.lng, widget.center.lat, widget.center.lng); 
  	String scheduleString = truck.isOpen ? "Is Open, from ${truck.schedule.start} - ${truck.schedule.end}" : "Closed";
    bool isFavorite = User().isFavTruck(truck.username);
    return Container(
           padding: EdgeInsets.fromLTRB(10,10,10,10),
           height: 220,
           width: double.maxFinite,
           child: Card(
             elevation: 5,
             child: InkWell(
               onTap: () => _onCardTap(truck),
	           child: Padding(
	             padding: EdgeInsets.only(left: 10, right: 10),
	             child: Column(
	                 children: <Widget>[
	                   Row(
	                     children: <Widget>[
	                       Text(truck.displayedName), 
	                       Semantics(
		                    label: isFavorite ? 'Remove From Favorites': 'Add To Favorites',
		                    button: true,
		                    child:Padding(padding: EdgeInsets.all(3), 
		                      child: Image.asset(isFavorite?'images/icon-star-selected.png':'images/icon-star.png'))) // Semantic
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTruckLists(),
     );
  }
}