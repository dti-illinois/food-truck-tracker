import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../utils/Utils.dart';

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
        isOpen: json['is_open'] ??  false,
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
      'weekly_schedule': weeklySchedule.toJson(),
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
  Location.emptyLocation() {
    this.lat = 0;
    this.lng = 0;
    this.location_name = "None";
  }
	factory Location.fromJson(Map<String, dynamic> json) {
		return new Location(lat: json['lat'],
							 lng: json['lng'],
               location_name: json['location_name'], 
               );
	}

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'location_name': location_name};
  }
  String toString() {
    return location_name??"(${lat.toStringAsFixed(1)}, ${lng.toStringAsFixed(1)})";
  }
}

class Schedule {
	TimeOfDay start;
	TimeOfDay end;
	Schedule({this.start,this.end});
  Schedule.fromTimeOfDay(TimeOfDay todStart, TimeOfDay todEnd) {
    start = todStart;
    end = todEnd;
  }
	factory Schedule.fromJson(Map<String, dynamic> json) {
    if (json['start'] == null || json['end'] == null) {
      return new Schedule();
    }
		return new Schedule(start: TimeUtils.timeOfDayFromTimestamp(json['start'].split(new RegExp(r"\.|\+"))[0]), 
			end: TimeUtils.timeOfDayFromTimestamp(json['end'].split(new RegExp(r"\.|\+"))[0]));
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
    return {'start': TimeUtils.timestampFromTimeOfDay(start), 'end': TimeUtils.timestampFromTimeOfDay(end)};
  }
}

enum WeekDay { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

class WeekDayHelper {
  static String weekdayToString(WeekDay day) {
    switch(day) {
      case WeekDay.Monday: return 'Monday';
      case WeekDay.Tuesday: return 'Tuesday';
      case WeekDay.Wednesday: return 'Wednesday';
      case WeekDay.Thursday: return 'Thursday';
      case WeekDay.Friday: return 'Friday';
      case WeekDay.Saturday: return 'Saturday';
      case WeekDay.Sunday: return 'Sunday';
      default:         return '';
    }
  }

  static WeekDay weekdayFromString(String weekdayString) {
    if (weekdayString != null) {
      if (weekdayString == 'Monday') {
        return WeekDay.Monday;
      }
      else if (weekdayString == 'Tuesday') {
        return WeekDay.Tuesday;
      }
      else if (weekdayString == 'Wednesday') {
        return WeekDay.Wednesday;
      }
      else if (weekdayString == 'Thursday') {
        return WeekDay.Thursday;
      }
      else if (weekdayString == 'Friday') {
        return WeekDay.Friday;
      }
       else if (weekdayString == 'Saturday') {
        return WeekDay.Saturday;
      }
      else if (weekdayString == 'Sunday') {
        return WeekDay.Sunday;
      }
    }
    return null;
  }

  static List<dynamic> weekdayToList(List<WeekDay> weekdays) {
    if (weekdays == null) {
      return null;
    }
    else {
      List<String> weekdaysList = new List<String>();
      for (WeekDay day in weekdays) {
        weekdaysList.add(WeekDayHelper.weekdayToString(day));
      }
      return weekdaysList;
    }
  }
}

class WeeklySchedule {
  List<WeeklyScheduleItem> scheduleItems;
  WeeklySchedule({this.scheduleItems});
  factory WeeklySchedule.fromWeeklyScheduleItemsJson(List<dynamic> items) {
    if (items == null) {
      return new WeeklySchedule(scheduleItems: []);
    }
    return new WeeklySchedule(scheduleItems: items.map((item) => WeeklyScheduleItem.fromJson(item)).toList());
  }
  void reorderItem() {
    scheduleItems.sort((a, b) {
      int aidx = WeekDayHelper.weekdayFromString(a.weekday).index;
      int bidx = WeekDayHelper.weekdayFromString(b.weekday).index;
      if (aidx < bidx) return -1;
      if (aidx > bidx) return 1;
      if(TimeUtils.compareTOD(a.start, b.start) < 0) {
        return -1;
      } else if (TimeUtils.compareTOD(a.start, b.start) > 0) {
        return 1;
      }
      if(TimeUtils.compareTOD(a.end, b.end) < 0) {
        return -1;
      } else if (TimeUtils.compareTOD(a.end, b.end) > 0) {
        return 1;
      }
      return 0;
    });
  }
  List<dynamic> toJson() {
    return scheduleItems.map((item) => item.toJson()).toList();
  }
}

class WeeklyScheduleItem {
  TimeOfDay start;
  TimeOfDay end;
  Location location;
  String weekday; 
  WeeklyScheduleItem({this.start, this.end, this.location, this.weekday});
  factory WeeklyScheduleItem.fromJson(Map<String, dynamic> json) {
    return new WeeklyScheduleItem(
        start: TimeUtils.timeOfDayFromTimestamp(json['start'].split(new RegExp(r"\.|\+"))[0]), 
        end: TimeUtils.timeOfDayFromTimestamp(json['end'].split(new RegExp(r"\.|\+"))[0]),
        location: Location.fromJson(json['location']),
        weekday: json['week_day'],
      );
  }
  Map<String, dynamic> toJson() {
    return {
      'start': TimeUtils.timestampFromTimeOfDay(start),
      'end': TimeUtils.timestampFromTimeOfDay(end),
      'location': location.toJson(),
      'week_day': weekday,
    };
  }
}