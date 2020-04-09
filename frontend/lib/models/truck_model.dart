import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TruckModel{
	String displayedName;
	String username;
	Location location; 
	Schedule schedule;
	String description;
	List<Tag> tags;
  bool isOpen;

	TruckModel({this.username, this.displayedName, this.location, 
    this.schedule, this.description='', this.tags=const [],
    this.isOpen});

	factory TruckModel.fromJson(Map<String, dynamic> json) {
		return new TruckModel(
				username: json['username'],
				displayedName: json['displayed_name'],
				location: Location.fromJson(json['location']),
				schedule: Schedule.fromJson(json['schedule']),
				description: json['description'],
				tags: TagHelper.tagsFromList(json['tags']),
        isOpen: json['is_open'],
			);
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
		return new Schedule(start: json['start'].split(new RegExp(r"\.|\+"))[0], 
			end: json['end'].split(new RegExp(r"\.|\+"))[0]);
	}
	String toString() {
		return '${this.start} - ${this.end}';
	}
}