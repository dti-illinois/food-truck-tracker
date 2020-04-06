import 'package:flutter/material.dart';
import 'truck_panel.dart';
import 'truck_detail.dart';
import 'truck_direction_map_view.dart';

void main() => runApp(FoodTruckTracker());

class FoodTruckTracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rokwire FoodTruckTracker',
      initialRoute: 'trucks',
      onGenerateRoute: (settings) {
          if (settings.name == "truck_detail") {
            return MaterialPageRoute(
              builder: (context) {
                return TruckDetailView(truck: settings.arguments);
              },
            );
          } else if (settings.name == "truck_direction_map") {
            return MaterialPageRoute(
              builder: (context) {
                MapDirectionViewArguments args = settings.arguments;
                return MapDirectionView(curLocation: args.curLocation, targetLocation: args.targetLocation);
              },
            );
          }
      },
      routes: {
        'trucks': (context) => TruckPanel(),
      },
      theme: ThemeData(
          primaryColor: Colors.purple,
      ),
    );
  }
}