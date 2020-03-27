import 'user_service.dart';
import 'temp_data.dart';

class User {
	static final User _instance = User._internal();
	UserModel _userModel;
	User._internal() {
		getUser(USERNAME).then((UserModel user) {
			_userModel = user;
		});
	}
	factory User() {
		return _instance;
	}
	bool isFavTruck(String truckname) {
	  	return _userModel?.isFavTruck(truckname) ?? false;
	  }

}

class UserModel {	
	final String username;
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
	print(json['fav_trucks']);
    return new UserModel(
        username: json['username'],
        favTrucks: favTrucksFromList(json['fav_trucks']),
    );
  }

  // String get username {
  // 	return _username;
  // }

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
  	if(isFavTruck(truckname)) {
  		favTrucks.add(truckname);
  	} else {
  		favTrucks.remove(truckname);
  	}
  }

  bool isFavTruck(String truckname) {
  	return favTrucks.contains(truckname);
  }
}