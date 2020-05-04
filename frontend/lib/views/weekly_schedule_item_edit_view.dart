import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/truck_model.dart';

class WeeklyScheduleItemEditViewArguments {
	WeeklyScheduleItem wkitem;
	Function onSave;
	Function onDelete; 
	WeeklyScheduleItemEditViewArguments({this.wkitem, this.onSave, this.onDelete});
}

class WeeklyScheduleItemEditView extends StatefulWidget {

	static String id = "WeeklyScheduleItemEdit";
	WeeklyScheduleItem wkitem;
	WeeklyScheduleItemEditView({@required this.wkitem});

	@override 
	 _WeeklyScheduleItemEditState createState() =>
    	_WeeklyScheduleItemEditState();
}

class _WeeklyScheduleItemEditState extends State<WeeklyScheduleItemEditView> {
	
	Widget _weekdaySelection() {
		return Container();
	}

	Widget _startTimeSelection() {
		return Container();
	}

	Widget _endTimeSelection() {
		return Container();
	}

	Widget _locationSelection() {
		return Container();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
				child: Column(
					children: <Widget> [
						_weekdaySelection(), 
						_startTimeSelection(),
						_endTimeSelection(),
						_locationSelection(),
					]
				)// Column
			) ;//Container 
	}
}
