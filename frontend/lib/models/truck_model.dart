import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TruckModel {
	String displayedName;
	String username;
	Location location; 
	Schedule schedule;
	String description;
	List<Tag> tags;
  bool isOpen;
  WeeklySchedule weeklySchedule;

	TruckModel({this.username, this.displayedName, this.location, 
    this.schedule, this.description='', this.tags=const [],
    this.isOpen, this.weeklySchedule});

	factory TruckModel.fromJson(Map<String, dynamic> json) {
		return new TruckModel(
				username: json['username'],
				displayedName: json['displayed_name'],
				location: Location.fromJson(json['location']),
				schedule: Schedule.fromJson(json['schedule']),
				description: json['description'],
				tags: TagHelper.tagsFromList(json['tags']),
        isOpen: json['is_open'],
        weeklySchedule: WeeklySchedule.fromWeeklyScheduleItemsJson(json['weekly_schedule']),
			);
	}

  Map<String, dynamic> toJson() {
    // print(displayedName);
    var map = {
      'displayed_name': displayedName,
      'location': location.toJson(),
      'schedule': schedule.toJson(),
      'description': description,
      'tags': TagHelper.tagsToList(tags),
    };
    return map;
  }
}

enum Tag { Savory, Sweet, Vegetarian, Free }

class TagHelper {
  static String tagToString(Tag tag) {
    switch(tag) {
      case Tag.Savory: return 'Savory';
      case Tag.Sweet: return 'Sweet';
      case Tag.Vegetarian:  return 'Vegetarian';
      case Tag.Free:  return 'Free';
      default:                      return null;
    }
  }

  static Tag tagFromString(String tagString) {
    if (tagString != null) {
      if (tagString == 'Savory') {
        return Tag.Savory;
      }
      else if (tagString == 'Sweet') {
        return Tag.Sweet;
      }
      else if (tagString == 'Vegetarian') {
        return Tag.Vegetarian;
      }
      else if (tagString == 'Free') {
        return Tag.Free;
      }
    }
    return null;
  }

  static String tagToImageAsset(Tag tag) {
    return null;
  }

  static Image tagIcon(Tag tag) {
    return (tag != null) ? Image.asset(tagToImageAsset(tag)) : null;
  }

  static List<Tag> tagsFromList(List<dynamic> tagsList) {
    if (tagsList == null) {
      return null;
    }
    else {
      List<Tag> tags = new List<Tag>();
      for (String tag in tagsList) {
        tags.add(TagHelper.tagFromString(tag));
      }
      return tags;
    }
  }

  static List<dynamic> tagsToList(List<Tag> tags) {
    if (tags == null) {
      return null;
    }
    else {
      List<String> tagsList = new List<String>();
      for (Tag tag in tags) {
        tagsList.add(TagHelper.tagToString(tag));
      }
      return tagsList;
    }
  }
}

class Location {
	double lat;
	double lng;
  String location_name; 
	Location({this.lat, this.lng, this.location_name});
	factory Location.fromJson(Map<String, dynamic> json) {
		return new Location(lat: json['lat'],
							 lng: json['lng'],
               location_name: json['location_name'], 
               );
	}

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'location_name': location_name};
  }
}

class Schedule {
	String start;
	String end;
	Schedule({this.start,this.end});
  Schedule.fromTimeOfDay(TimeOfDay todStart, TimeOfDay todEnd) {
    start = _formatTimeOfDay(todStart);
    end = _formatTimeOfDay(todEnd);
  }
	factory Schedule.fromJson(Map<String, dynamic> json) {
		return new Schedule(start: json['start'].split(new RegExp(r"\.|\+"))[0], 
			end: json['end'].split(new RegExp(r"\.|\+"))[0]);
	}
	String toString() {
		return '${this.start} - ${this.end}';
	}

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return dt.toIso8601String();
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end};
  }
}

class WeeklySchedule {
  List<WeeklyScheduleItem> scheduleItems;
  WeeklySchedule({this.scheduleItems});
  factory WeeklySchedule.fromWeeklyScheduleItemsJson(List<dynamic> items) {
    return new WeeklySchedule(scheduleItems: items.map((item) => WeeklyScheduleItem.fromJson(item)).toList());
  }
}

class WeeklyScheduleItem {
  String start;
  String end;
  Location location;
  String weekday; 
  WeeklyScheduleItem({this.start, this.end, this.location, this.weekday});
  factory WeeklyScheduleItem.fromJson(Map<String, dynamic> json) {
    return new WeeklyScheduleItem(
        start: json['start'].split(new RegExp(r"\.|\+"))[0], 
        end: json['end'].split(new RegExp(r"\.|\+"))[0],
        location: Location.fromJson(json['location']),
        weekday: json['week_day'],
      );
  }
}