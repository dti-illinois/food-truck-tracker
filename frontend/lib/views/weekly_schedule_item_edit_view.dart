import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/truck_model.dart';
import '../utils/Utils.dart';
import '../widgets/header_bar.dart';
import '../widgets/location_editable_display.dart';
import '../widgets/timestamp_editable_display.dart';

class WeeklyScheduleItemEditViewArguments {
	WeeklyScheduleItem wkitem;
	bool isNewItem;
	Function onSave;
	Function onDelete; 
	WeeklyScheduleItemEditViewArguments({this.wkitem, this.isNewItem, this.onSave, this.onDelete});
}

class WeeklyScheduleItemEditView extends StatefulWidget {

	static String id = "WeeklyScheduleItemEdit";
	WeeklyScheduleItem wkitem;
	bool isNewItem;
	Function onSave;
	Function onDelete; 
	WeeklyScheduleItemEditView({@required this.wkitem, this.isNewItem=false, this.onSave, this.onDelete});

	@override 
	 _WeeklyScheduleItemEditState createState() =>
    	_WeeklyScheduleItemEditState();
}

class _WeeklyScheduleItemEditState extends State<WeeklyScheduleItemEditView> {
	
	String _selectedDay;
	TimeOfDay _startTime;
	TimeOfDay _endTime;
	Location _location;
  	TextEditingController _locationNameController;

	@override
	void initState() {
		_selectedDay = widget.wkitem.weekday;
		_startTime = widget.wkitem.start;
		_endTime = widget.wkitem.end;
		_location = widget.wkitem.location;
  		_locationNameController = TextEditingController(text:widget.wkitem.location.toString());
  		_locationNameController.addListener(() {_location.location_name = _locationNameController.text;});
	}

	@override
	void dispose(){
		_locationNameController.dispose();
    	super.dispose();
	}

	List<Widget> _weekdayDropdownItems() {
		return WeekDay.values.map<DropdownMenuItem<String>>((WeekDay weekday) {
	        return DropdownMenuItem<String>(
	          value: WeekDayHelper.weekdayToString(weekday),
	          child: Text(WeekDayHelper.weekdayToString(weekday)),
	        );
	    }).toList();
	}

	Widget _weekdaySelection() {
		return DropdownButton<String>(
					value: _selectedDay,
					iconSize: 30,
					isExpanded: true,
					elevation: 16,
					style: TextStyle(color: UiColors.darkBlueGrey, fontSize: 20),
					onChanged: (String newDay) {
				        setState(() {
				          _selectedDay = newDay;
				        });
				      },
				    items: _weekdayDropdownItems(),
				); // DropdownButton
	}

	Future<TimeOfDay> _pickTime(TimeOfDay initialTime) async {
	    TimeOfDay time =
	        await showTimePicker(context: context, initialTime: initialTime);
	    return time;
	}

	void _onTapStartTime(TimeOfDay newTime) async {
		if (newTime != null) 
			setState(() {
				_startTime = newTime;
			});
	}

	void _onTapEndTime(TimeOfDay newTime) async {
		if (newTime != null) 
			setState(() {
				_endTime = newTime;
		});
	}

	Widget _startTimeSelection() {
		return Row(
			children: <Widget>[
				Expanded(child: TimestampEditableDisplay(time: _startTime, onTap: _onTapStartTime))
			]);
	}

	Widget _endTimeSelection() {
		return Row(
			children: <Widget>[
				Expanded(child: TimestampEditableDisplay(time: _endTime, onTap: _onTapEndTime))
			]);
	}

	void _onTapEditLocation(Location newLocation) {
		this.setState(() {
			_location = newLocation;
			});
	}

	Widget _locationSelection() {
		return LocationEditableDisplay(location: _location, onTap: _onTapEditLocation, locationEditable: true, locationNameEditable: true, controller: _locationNameController);
	}

	Widget _timeSelection() {
		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: <Widget>[
			Padding(
                    padding: EdgeInsets.only(right: 10, top: 15),
                    child:Image.asset('images/icon-time.png'),), // Padding 
			Expanded(child: Column(
					children: <Widget> [
						_weekdaySelection(),
						_startTimeSelection(),
						_endTimeSelection(),
					]
			) //Column
			)// Expand
		]);
	}

	void _onScheduleItemSave() {
		widget.wkitem.weekday = _selectedDay;
		widget.wkitem.start = _startTime;
		widget.wkitem.end = _endTime;
		widget.wkitem.location = _location;
		if(widget.onSave != null) {
			widget.onSave();
		}
		Navigator.pop(context);
	}

	@override
	Widget build(BuildContext context) {
		return 
			Scaffold(
				appBar: _HeaderBar(
					context: context,
					titleWidget: Text( widget.isNewItem ? "Add Schedule" : "Edit Schedule",
					  style: TextStyle(
					      color: Colors.white,
					      fontSize: 16,
					      fontWeight: FontWeight.w900,
					      letterSpacing: 1.0),
						),
					onSavePressed: _onScheduleItemSave,
				), // appBar 
				body: Center(child: 
					Padding(
						padding: EdgeInsets.symmetric(horizontal: 10),
						child: Column(
					        children: <Widget>[Expanded(
					        	child: Container(
					          		color: Colors.white,
									child: Column(
										children: <Widget> [
											_timeSelection(),
											_locationSelection(),
										]
									)// Column
								)// Container
							)]// Expanded
					        )// Column
				)) // Center
			);// Scallfold 
	}
}


class _HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final Widget titleWidget;
  final String backIconRes;
  final String saveIconRes;
  final Function onBackPressed;
  final Function onSavePressed;

  _HeaderBar({@required this.context, this.titleWidget, this.onBackPressed, this.onSavePressed, this.saveIconRes = "images/icon-selected.png", this.backIconRes = 'images/chevron-left-white.png'});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:  IconButton(
              icon: Image.asset(backIconRes),
              onPressed: _onTapBack),
      title: titleWidget,
      centerTitle: true,
      actions: <Widget>[
      	IconButton(
              icon: Image.asset(saveIconRes),
              onPressed: _onTapSave)
      ],
    );
  }

  void _onTapBack() {
    if (onBackPressed != null) {
      onBackPressed();
    } else {
      Navigator.pop(context);
    }
  }

  void _onTapSave() {
  	if (onSavePressed != null) {
  		onSavePressed();
  	} 
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
