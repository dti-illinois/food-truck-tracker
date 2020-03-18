import 'package:flutter/material.dart';
import 'truck_panel.dart';

void main() => runApp(FoodTruckTracker());

class FoodTruckTracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rokwire FoodTruckTracker',
      initialRoute: 'trucks',
      routes: {
        'trucks': (context) => TruckPanel(),
      },
      theme: ThemeData(
          primaryColor: Colors.purple,
        )
    );
  }
}