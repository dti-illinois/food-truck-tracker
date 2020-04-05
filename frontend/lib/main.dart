import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';
import 'views/truck_panel.dart';
import 'views/truck_detail.dart';

void main() async {
  await _initServices();
  runApp(
    ChangeNotifierProvider(
        child: FoodTruckTracker(),
        create: (context) => User(),
      )
    );
}

void _initServices() async {
  await User().initService();
}

class FoodTruckTracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rokwire FoodTruckTracker',
      initialRoute: 'trucks',
      onGenerateRoute: (settings) {
          if (settings.name == "truck_detail") {
            final TruckDetailArgument args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return TruckDetailView(truck: args.truck, center: args.center);
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