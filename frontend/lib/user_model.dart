class UserModel {	
	final String username;
	Set<String> favTrucks; 
	
	UserModel({ this.username, this.favTrucks});

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
        favTrucks: json['fav_trucks'],
    );
  }

  // String get username {
  // 	return _username;
  // }

  // Set<String> get favTrucks {
  // 	return _favTrucks;
  // }

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