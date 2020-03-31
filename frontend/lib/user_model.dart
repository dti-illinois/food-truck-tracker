
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
    print(favTrucks);
  	if(!isFavTruck(truckname)) {
      print("adding");
  		favTrucks.add(truckname);
  	} else {
      print("removing");
  		favTrucks.remove(truckname);
  	}
    print("after");
    print(favTrucks);
  }

  bool isFavTruck(String truckname) {
    print("${favTrucks} ${truckname} ${favTrucks.contains(truckname)}");
  	return favTrucks.contains(truckname);
  }
}