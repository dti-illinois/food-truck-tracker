import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';
import 'views/login_view.dart';
import 'views/search_panel.dart';
import 'views/truck_detail.dart';
import 'views/truck_direction_map_view.dart';
import 'views/truck_edit_view.dart';
import 'views/truck_management_view.dart';
import 'views/truck_panel.dart';
import 'views/weekly_schedule_item_edit_view.dart';

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
          } else if (settings.name == TruckManagementView.id) {
            return MaterialPageRoute(
              builder: (context) {
                return TruckManagementView(vendorUsername: settings.arguments);
              },
            );
          } else if (settings.name == MapDirectionView.id) {
            return MaterialPageRoute(
              builder: (context) {
                MapDirectionViewArguments args = settings.arguments;
                return MapDirectionView(curLocation: args.curLocation, targetLocation: args.targetLocation);
              },
            );
          } else if (settings.name == TruckEditView.id) {
            return MaterialPageRoute(
              builder: (context) {
                return TruckEditView(truck: settings.arguments);
              },
            );
          } else if (settings.name == WeeklyScheduleItemEditView.id) {
            return MaterialPageRoute(
              builder: (context) {
                WeeklyScheduleItemEditViewArguments args = settings.arguments;
                return WeeklyScheduleItemEditView(wkitem: args.wkitem);
              },
            );
          }
      },
      routes: {
        TruckPanel.id: (context) => TruckPanel(),
        LoginView.id: (context) => LoginView(),
        SearchPanel.id: (context) => SearchPanel(),
      },
      theme: ThemeData(
          primaryColor: Color(0xff002855),
      ),
    );
  }
}