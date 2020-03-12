import "truck_model.dart";
import "package:http/http.dart" as http;
import 'dart:convert';

var host = 'http://0.0.0.0:5000';

Future<List<TruckModel>> getFoodTruckList() async {
  final response = await http.get(host+'/vendor/');
  if (response.statusCode == 200) {
 	List<Map<String, dynamic>> l = List.from(jsonDecode(response.body));
 	List<TruckModel> trucks = [];
 	l.forEach((model) {
        trucks.add(TruckModel.fromJson(model));
 	}
    );
    return trucks;
  } else {
    throw Exception('Failed to load trucks');
  }
}