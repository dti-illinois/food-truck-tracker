import 'package:provider/provider.dart';

enum UserType { Vendor, User, Guest }

class UserModel {	
	final String username;
  UserType _type;
	Set<String> favTrucks; 
	
	UserModel({this.username, this.favTrucks});

	toJson() {
	    return {
	      "username": username,
	      "fav_trucks": favTrucks.toList(),
	    };
	  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
	}
    return new UserModel(
        username: json['username'],
        favTrucks: favTrucksFromList(json['fav_trucks']),
    );
  }

  UserType get userType {
  	return _type;
  }

  void set userType(UserType type) {
    _type = type;
  }

  // Set<String> get favTrucks {
  // 	return _favTrucks;
  // }

  static Set<String> favTrucksFromList(List<dynamic> truckList) {
  	if (truckList == null) {
      return null;
    }
    else {
      Set<String> truckUsernames = new Set<String>();
      for (String t in truckList) {
        truckUsernames.add(t);
      }
      return truckUsernames;
    }
  }

  void toggleFavTruck(String truckname) {
  	if(!isFavTruck(truckname)) {
  		favTrucks.add(truckname);
  	} else {
  		favTrucks.remove(truckname);
  	}
  }

  bool isFavTruck(String truckname) {
  	return favTrucks.contains(truckname);
  }
}