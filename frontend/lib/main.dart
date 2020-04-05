import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';
import 'views/login_view.dart';
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
      initialRoute: LoginView.id,
      onGenerateRoute: (settings) {
          if (settings.name == TruckDetailView.id) {
            final TruckDetailArgument args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return TruckDetailView(truck: args.truck, center: args.center);
              },
            );
          }
      },
      routes: {
        TruckPanel.id: (context) => TruckPanel(),
        LoginView.id: (context) => LoginView(),
      },
      theme: ThemeData(
          primaryColor: Color(0xff002855),
      ),
    );
  }
}