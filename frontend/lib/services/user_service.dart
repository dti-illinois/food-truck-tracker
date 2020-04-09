import '../config.dart';
import "../models/user_model.dart";

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

var host = 'http://0.0.0.0:5000';
var USER_URL = host + "/user"; 


class User extends ChangeNotifier {
  static final User _instance = User._internal();
  UserModel _userModel;
  User._internal();

  factory User() {
    return _instance;
  }

  Future<void> initService() async {
    // TODO: treat as default user 
    // await getUser(USERNAME).then((UserModel user) {
    //   _userModel = user;
    // });
  }

  bool isFavTruck(String truckname) {
      return _userModel?.isFavTruck(truckname) ?? false;
    }

  void toggleFavTruck(String truckname) {
    _userModel?.toggleFavTruck(truckname);
    notifyListeners();
  }

  UserType get userType {
    return _userModel.userType;
  }

  void set userType(UserType type) {
   _userModel.userType = type;
  }

  String get username {
    return _userModel.username;
  }

  Future<void> updateUser(String username, UserType type) async {
    if (type == UserType.User) {
      await getUser(username).then((UserModel user) {
            _userModel = user;
            _userModel.userType = type;
          });
    } else if (type == UserType.Guest) {
      _userModel = new UserModel();
      _userModel.userType = type;
    }
  }

}


Future<UserModel> getUser(String username) async {
  final response = await http.get(USER_URL + "/" + username);
  if (response.statusCode == 200) {
 	return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

void putUser(UserModel user) {
  // TODO: implement put 
  // final response = await http.get(USER_URL + username);
}