# Backend

This is the server for the Food Truck Tracker project 

## Set up
### MongoDB

MongoDB should be installed. You could also use MongoDB ATLAS 

### Configuration

The necessary configuration should be configured in configure file (config.py) that is located under app folder. This contains the MongoDB url, database name, and so on. Modify the information in the file appropriately.

## Environment File 
Please create an `.env` file that contains the following variables 
```
MONGODB_USERNAME=
MONGODB_PASSWORD=
MONGODB_HOSTNAME=
MONGODB_PARAMS=
MONGODB_DATABASE=
```

## Run the Application 
### To Run Locally 
This service uses the python Flask and MongoEngine library.

The configuration file config.py should have the appropriate information

To install and run the location-model service, do the following:

```
cd backend
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py run
```

The profile building block should be running at http://localhost:5000. The detailed API information is in the .py files of the `/controller` folder and `/utils/dto.py` file.

### To Run with Docker 

```
cd backend
docker-compose build --no-cache
docker-compose up --force-recreate
```

## Sample Trucks for Post Endpoint

Let us use curl command to post two sample trucks to the server running at http://localhost:5000/vendor.

```
curl -d '{
  "username": "PBJ",
  "weekly_schedule": [
    {
      "start": "2020-05-05T21:37:00.000",
      "location": {
        "lng": -88.26373,
        "location_name": "W Union St, Champaign, IL, USA",
        "lat": 40.1136009
      },
      "week_day": "Monday",
      "end": "2020-05-05T22:37:00.000"
    },
    {
      "start": "2020-05-05T03:00:00.000",
      "location": {
        "lng": -45.3,
        "location_name": "union",
        "lat": 89.23
      },
      "week_day": "Tuesday",
      "end": "2020-05-05T05:00:00.000"
    }
  ],
  "description": "only $99",
  "tags": [
    "Savory",
    "Vegetarian"
  ],
  "displayed_name": "yum pb",
  "location": {
    "lng": -45.3,
    "location_name": "union",
    "lat": 89.23
  },
  "is_open": true,
  "schedule": {
    "start": "2020-05-05T03:00:00.000",
    "end": "2020-05-05T15:00:00.000"
  }
}' -H "Content-Type: application/json" -X POST http://localhost:5000/vendor
```

```
curl -d '{
  "username": "tokoyaki",
  "weekly_schedule": [
     {
      "start": "2020-05-05T13:23:00.000",
      "location": {
        "lng": -88.2249052,
        "location_name": "201 N Goodwin Ave, Urbana, IL 61801, USA",
        "lat": 40.11380279999999
      },
      "week_day": "Friday",
      "end": "2020-05-05T14:23:00.000"
    },
    {
      "start": "2020-05-05T13:00:00.000",
      "location": {
        "lng": -45.3,
        "location_name": "island",
        "lat": 89.23
      },
      "week_day": "Saturday",
      "end": "2020-05-05T15:00:00.000"
    }
  ],
  "description": "",
  "tags": [],
  "displayed_name": "Best Tokoyaki",
  "location": {
    "lng": 0,
    "location_name": "",
    "lat": 0
  },
  "is_open": false,
  "schedule": {
    "start": "2020-05-03T21:23:22.000",
    "end": "2020-05-03T23:23:22.000"
  }
}' -H "Content-Type: application/json" -X POST http://localhost:5000/vendor/
```
It will return back the post status in json which includes the newly posted object. 
Note that the time format is `%Y-%m-%dT%H:%M:%S.000`

## Sample User for Post Endpoint
```
curl -d '{
  "username": "apple",
  "fav_truck": []
}' -H "Content-Type: application/json" -X PUT http://localhost:5000/user
```
It will create a new user with username `apple`
## One Example of Using Put Endpoint:
```
curl -d '{
  "tags": [
      "Sweet",
      "Free"
  ],
  "displayed_name": "Peanut Butter Fairy"
}' -H "Content-Type: application/json" -X PUT http://localhost:5000/vendor/PBJ
```
It will return back the post status in json which includes the updated object. 
Note that the time format is `%Y-%m-%dT%H:%M:%S.000`

## One Example of Updating User's Favorite Foodtruck
`curl -d '{"fav_trucks": ["PBJ"]}' -H "Content-Type: application/json" -X PUT http://localhost:5000/vendor/fav_trucks/apple`
It will update `apple`'s favorite truck to `["PBJ"]`

## One Example of Getting List of Vendors:
`curl -X GET http://localhost:5000/vendor`

It will return a list of general information of vendors. 

Current query params are supported:  
### Username search: 
This query will return back all trucks whose username is `PBJ`.
`/vendor?usernames=PBJ`
This query will return back all trucks whose username is one of `PBJ` and `tokoyaki`.
`/vendor?usernames=PBJ&usernames=tokoyaki`

### displayed_name search: 
This query will return back all trucks whose display name contains the word `Tokoyaki`.
`/vendor?displayed_name=Tokoyaki`

### Tags search: 
This query will return back all trucks whose tags contains the word and `Sweet`.
`/vendor/?tags=Sweet`
Please see all the support tags in the `model/vendor_model.py` file 

## One Example of Getting a Vendor:
This query will return the detailed informaiton of a vendor, including its weekly schedule and description 
`curl -X GET http://localhost:5000/vendor/PBJ`

## One Example of User's Favorite Vendor:
This query will return the general informaiton of a list of truck that user `apple` liked
`curl -X GET http://localhost:5000/vendor/fav_trucks/apple`




