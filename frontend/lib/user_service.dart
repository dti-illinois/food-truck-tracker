import "user_model.dart";
import "package:http/http.dart" as http;
import 'dart:convert';

var host = 'http://0.0.0.0:5000';
var USER_URL = host + "/user"; 

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