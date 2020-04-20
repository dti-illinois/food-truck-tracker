import 'package:flutter/material.dart';
import '../config.dart';
import '../utils/Utils.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../views/truck_management_view.dart';
import '../views/truck_panel.dart';

class LoginView extends StatelessWidget {

	static String id = "login";

	void _onLogin(BuildContext context, String username, UserType type) {
		if (type == UserType.User || type == UserType.Guest) {
			print(username);
			User().updateUser(username, type);
			Navigator.pushNamed(context, TruckPanel.id);
		} else if (type == UserType.Vendor) {
			// TODO: pass in vendor username to get corresponding view
			Navigator.pushNamed(context, TruckManagementView.id, arguments: username);
		}
	}

	Widget _roleSelectionButton(BuildContext context, String text, Function onTap) {
		return Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: UiColors.darkSlateBlue,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: onTap,
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
	}



	@override
	Widget build(BuildContext context) {
		return Scaffold(
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "images/group-5-blue.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
					_roleSelectionButton(context, 'Vendor', () => _onLogin(context, VENDOR_USERNAME, UserType.Vendor)),
                    SizedBox(height: 25.0),
					_roleSelectionButton(context, 'User', () => _onLogin(context, USERNAME, UserType.User)),
                    SizedBox(height: 25.0,),
					_roleSelectionButton(context, 'Guest', () => _onLogin(context, "", UserType.Guest)),
                    SizedBox(height: 15.0,),
                  ],
                ),
              ),
            ),
          ),
        );
		return Scaffold(
			body: 
				Container(
    				margin: const EdgeInsets.only(top: 300, bottom: 300),
    				padding: const EdgeInsets.all(4.0),
    				alignment: Alignment.center,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						mainAxisSize: MainAxisSize.max,
						children: <Widget> [
							Text("Please select the user type",
								style: TextStyle(fontWeight: FontWeight.bold),
								 textAlign: TextAlign.center,),
						],
					) // Column
				)// Container	
			);
	}
}