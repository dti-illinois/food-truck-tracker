import "truck_model.dart";
import "package:http/http.dart" as http;
import 'dart:convert';

var host = 'http://0.0.0.0:5000';

Future<List<TruckModel>> getFoodTruckList(bool onlyOpen, Tag tag) async {
	print(tag);
  final response = await http.get(host+'/vendor/');
  if (response.statusCode == 200) {
 	List<Map<String, dynamic>> l = List.from(jsonDecode(response.body));
 	List<TruckModel> trucks = [];
 	l.forEach((model) {
 		TruckModel truck = TruckModel.fromJson(model);
 		if ((tag == null || truck.tags.contains(tag))) {
 			    trucks.add(truck);
 		}
 	});
    return trucks;
  } else {
    throw Exception('Failed to load trucks');
  }
}

Future<TruckModel> getFoodTruck(String username) async {
	print(username);
  final response = await http.get(host+'/vendor/' + username);
  if (response.statusCode == 200) {
  	print(response.body);
 	return TruckModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load trucks');
  }
}