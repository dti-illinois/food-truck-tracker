import 'config.dart';
import "user_model.dart";

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
    await getUser(USERNAME).then((UserModel user) {
      _userModel = user;
    });
  }

  bool isFavTruck(String truckname) {
      return _userModel?.isFavTruck(truckname) ?? false;
    }

  void toggleFavTruck(String truckname) {
    _userModel?.toggleFavTruck(truckname);
    notifyListeners();
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