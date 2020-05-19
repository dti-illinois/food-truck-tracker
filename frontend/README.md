# frontend

This is a flutter prototype application for the Food Truck Tracker project. 

## Getting Started

Please follow the guideline on [the flutter documentation](https://flutter.dev/docs) to run the application. 

## Current Functionalities

Please see the demo video linked [here](https://drive.google.com/open?id=17y8xrUhPgRA1UpgmxHe9qjx_ixKUIcyw)

## Set up: 
1. obtain goole api key in google cloud platform by following the [instruction](https://developers.google.com/places/web-service/get-api-key#get_key)
   * The api requires `Places API, Maps SDK for Android, Maps SDK for iOS, and Places API`
   * open `frontend/android/app/src/main/AndroidManifest.xml`, replace `android:value` under the name `com.google.android.geo.API_KEY` with you own api key. 
   * open `frontend/ios/Runner/AppDelegate.swift`, replace parameter of `GMSServices.provideAPIKey([API_KEY])` with you own api key. 
2. Please create a file `secret.js` under the folder `/lib`, with format 
`const String GOOGLE_MAP_API_KEY=<YOUT_API_KEY>;`

## Run the app 
go to `/frontend` and run `flusk run` to start the front end