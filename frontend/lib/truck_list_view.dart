import 'package:flutter/material.dart';
import 'truck_model.dart';
import 'truck_service.dart';

class FoodTruckListView extends StatefulWidget {
	static String id = "foodtrucklistview";
	@override
	TruckListState createState() => TruckListState(); 
}

class TruckListState extends State<FoodTruckListView> {
	Future<List<TruckModel>> foodTruckList;

	@override
	void initState() {
		super.initState();
    	foodTruckList = getFoodTruckList();
	}

	Widget _buildTruckLists() {
		return 
			FutureBuilder(
				builder: (context, projectSnap) { 
					switch (projectSnap.connectionState) {
						case ConnectionState.none:
          				case ConnectionState.waiting:
          					return CircularProgressIndicator();
						default:
							return ListView.builder(
								itemBuilder: (context, i) {
									return _buildTruckCard(projectSnap.data[i]);
								},
							    itemCount: projectSnap.data.length,
							);
					}
				},
				future: getFoodTruckList(),
			);	
	}

	Widget _buildTruckCard(TruckModel truck) {
		return Container(
				   padding: EdgeInsets.fromLTRB(10,10,10,0),
				   height: 220,
				   width: double.maxFinite,
				   child: Card(
				     elevation: 5,
				     child: Padding(
			     		padding: EdgeInsets.only(left: 10, right: 10),
			     		child: Column(
			     				children: <Widget>[
			     					Row(
			     						children: <Widget>[
			     							Text(truck.displayedName), 
			     							IconButton(icon: new Icon(Icons.star)),
			     						],
			     						mainAxisAlignment: MainAxisAlignment.spaceBetween
			     					), // Row
			     					Row(
			     						children: <Widget>[
			     							 Column(
			     							 		crossAxisAlignment: CrossAxisAlignment.start,
				     								children: <Widget>[
				     									Text("schedule: ${truck.schedule.start} - ${truck.schedule.end}"),
				     									Text("location: ${truck.location.lat}, ${truck.location.lng}" ),
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
			     					Row(
			     						children: <Widget>[
			     							
			     						],
			     						mainAxisAlignment: MainAxisAlignment.spaceBetween
			     					), 
			     				], // Widget list
			     			), // Column
				     ), // Padding
				   ), // Card
				);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
	      appBar: AppBar(
	      	  title: const Text("Food Truck Lists"),
	          actions: <Widget>[
	          ]
	        ),
	      body: _buildTruckLists(),
	     );
	}
}