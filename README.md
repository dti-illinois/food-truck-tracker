front end: 
	obtain goole api key in google cloud platform by following the instruction: https://developers.google.com/places/web-service/get-api-key#get_key
	open "frontend/android/app/src/main/AndroidManifest.xml", replace "android:value" under the name "com.google.android.geo.API_KEY" with you own api key. 
	 open "frontend/ios/Runner/AppDelegate.swift",, replace parameter of "GMSServices.provideAPIKey([API_KEY])" with you own api key. 
	go to ./frontend/ and run "flusk run" to start the front end

back end:
	go to ./backend/ and run "python manager.py run" to start the server 
	to run the server in docker, run "docker-compose up -d" to start the server 
	you can go to 'localhost:5000' in the browser to test the api with the blueprint interface
