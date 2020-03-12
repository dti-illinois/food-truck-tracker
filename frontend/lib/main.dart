import 'package:flutter/material.dart';
import 'truck_list_view.dart';

void main() => runApp(FoodTruckTracker());

class FoodTruckTracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rokwire FoodTruckTracker',
      initialRoute: FoodTruckListView.id,
      routes: {
        FoodTruckListView.id: (context) => FoodTruckListView(),
      },
      theme: ThemeData(
          primaryColor: Colors.purple,
        )
    );
  }
}