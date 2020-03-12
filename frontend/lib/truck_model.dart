import 'package:intl/intl.dart';

class TruckModel{
	String displayedName;
	String username;
	Location location; 
	Schedule schedule;
	TruckModel({this.username, this.displayedName, this.location, this.schedule});
	factory TruckModel.fromJson(Map<String, dynamic> json) {
		print(json);
		return new TruckModel(
				username: json['username'],
				displayedName: json['displayed_name'],
				location: Location.fromJson(json['location']),
				schedule: Schedule.fromJson(json['schedule'])
			);
	}
}

class Location {
	double lat;
	double lng;
	Location({this.lat, this.lng});
	factory Location.fromJson(Map<String, dynamic> json) {
		return new Location(lat: json['lat'],
							 lng: json['lng']);
	}
}

class Schedule {
	String start;
	String end;
	Schedule({this.start,this.end});
	factory Schedule.fromJson(Map<String, dynamic> json) {
		return new Schedule(start: new DateFormat("hh:mm").format(DateTime.parse(json['start'])), 
			end: new DateFormat("hh:mm").format(DateTime.parse(json['end'])));
	}
}