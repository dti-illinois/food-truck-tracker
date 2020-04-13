import "package:http/http.dart" as http;
import 'dart:convert';
import "../models/truck_model.dart";

var host = 'http://0.0.0.0:5000';

Future<List<TruckModel>> getFoodTruckList(bool onlyOpen, Tag tag) async {
  final response = await http.get(host+'/vendor/');
  if (response.statusCode == 200) {
   	List<Map<String, dynamic>> l = List.from(jsonDecode(response.body));
   	List<TruckModel> trucks = [];
   	l.forEach((model) {
   		TruckModel truck = TruckModel.fromJson(model);
   		if ((tag == null || truck.tags.contains(tag)) 
   			&& (!onlyOpen || truck.isOpen)) {
   			    trucks.add(truck);
   		}
   	});
      return trucks;
  } else {
    throw Exception('Failed to load trucks');
  }
}

Future<TruckModel> getFoodTruck(String username) async {
  final response = await http.get(host+'/vendor/' + username);
  if (response.statusCode == 200) {
   	return TruckModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load trucks');
  }
}

Future<List<TruckModel>> searchTrucks({String searchInput}) async {
  if (searchInput.isEmpty) {
      return null;
    }
    return getFoodTruckList(false, null); // TODO: remove this and impl search func 
    http.Response response;
    try {
      // var params = _constructSearchParams(searchInput);
      // response = (Config().eventsOrConvergeUrl != null) ? await Network().get('${Config().eventsOrConvergeUrl}$params', auth: NetworkAuth.App, headers: _stdEventsHeaders) : null;
    } catch (e) {
      print('Failed to search events with keyword: $searchInput');
      print(e.toString());
      return null;
    }
    if ((response != null) && (response.statusCode == 200)) {
      List<Map<String, dynamic>> l = List.from(jsonDecode(response.body));
      List<TruckModel> trucks = [];
      l.forEach((model) {
        TruckModel truck = TruckModel.fromJson(model);
        trucks.add(truck);
      });
      return trucks;
    } else {
      print('Failed to search events with keyword: $searchInput');
      print(response?.body);
      return null;
    }
}