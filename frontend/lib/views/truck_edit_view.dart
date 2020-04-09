import 'package:flutter/material.dart';

import '../models/truck_model.dart';
import '../models/user_model.dart';
import '../services/truck_service.dart';
import '../services/user_service.dart';
import '../utils/Utils.dart';
import '../views/truck_management_view.dart';
import '../widgets/header_bar.dart';

class TruckEditView extends StatefulWidget {
  static String id = "truck_edit";
  TruckModel truck;
  TruckEditView({this.truck});

  @override
  _TruckEditState createState() =>
    _TruckEditState();
}

class _TruckEditState extends State<TruckEditView> {
  TruckModel truck;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TimeOfDay startTime;
  TimeOfDay endTime;

  @override
  void initState() {
    super.initState();
    truck = widget.truck;
    _initTimeOfDay();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initTimeOfDay() {
    startTime = TimeOfDay.fromDateTime(DateTime.parse(truck.schedule.start));
    endTime = TimeOfDay.fromDateTime(DateTime.parse(truck.schedule.end));
    _titleController = TextEditingController(text: truck.displayedName);
    _descriptionController = TextEditingController(text: truck.description);
  }

  Widget _truckTitle() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _titleController,
                style: TextStyle(
                    fontSize: 24,
                    color: UiColors.darkSlateBlueTwo,
                    letterSpacing: 1),
              ),
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _saveFoodTruck,
                child: Semantics(
                    label: 'Save',
                    button: true,
                    child:Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10), 
                      child: Image.asset('images/icon-check-example.png')))
            ), // GestureDetector
          ],
    ));
  }

  Widget _truckDetails() {
    List<Widget> details = new List<Widget>();

    Widget location = _truckLocationDetail();
    if (location != null) {
      details.add(location);
    }

    Widget schedule = _truckScheduleDetail();
    if (schedule != null) {
      details.add(schedule);
    }

    Widget tags = _truckTags();
    if (tags != null) {
      details.add(tags);
    }

    return (0 < details.length)
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details))
        : Container();
  }

  Widget _truckLocationDetail() {
  	String locationText =  " (${truck.location.lat.toStringAsFixed(1)}, ${truck.location.lng.toStringAsFixed(1)})";
  	return Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child:Image.asset('images/icon-location.png'),
                    ),
                    height: 20,
                  ),
                
                Expanded(child: Text(locationText,
                    style: TextStyle(
                        fontFamily: 'ProximaNovaMedium',
                        fontSize: 16,
                        color: UiColors.bodyText))),
              ],
            ), // Row
        ); // Padding
  }

  Future<TimeOfDay> _pickTime(TimeOfDay initialTime) async {
    TimeOfDay time =
        await showTimePicker(context: context, initialTime: initialTime);
    return time;
  }

  void _onTapStartTime() async {
    TimeOfDay time =
        await _pickTime(startTime ?? (new TimeOfDay.now()));
    if (time != null) startTime = time;
    setState(() {});
  }

void _onTapEndTime() async {
    TimeOfDay time =
        await _pickTime(endTime ?? (new TimeOfDay.now()));
    if (time != null) endTime = time;
    setState(() {});
  }

  Widget _truckScheduleDetail() {
    print('${startTime}  ${truck.schedule.start}');
  	return Padding(
          padding: EdgeInsets.only(bottom: 11),
          child:Semantics(
            container: true,
          child:Column(
                children: <Widget>[
	              Semantics(
	              excludeSemantics: true,
	              label: 'displayTime',
	              child:
	                  Row(
	                    crossAxisAlignment: CrossAxisAlignment.center,
	                    children: <Widget>[
	                      Padding(
	                        padding: EdgeInsets.only(right: 10),
	                        child:Image.asset('images/icon-time.png'),),
	                      _ScheduleDisplayView(
                          label: TimeUtils.formatTimeOfDay(startTime),
                          onTap: _onTapStartTime,
                        ), 
                        _ScheduleDisplayView(
                          label: TimeUtils.formatTimeOfDay(endTime),
                          onTap: _onTapEndTime,
                        ), 
	                    ],
	                  ) // Row 
	               ), // Semantic
                ],
          )), // Semantics, Column  
      );
  }

  Widget _truckTags() {
  	List<Widget> widgetTags = [];
  	for(String tag in TagHelper.tagsToList(truck.tags)) {
  		widgetTags.add(Container(
  				alignment: Alignment.center,
  				padding: EdgeInsets.symmetric(horizontal: 20),
  				margin: EdgeInsets.only(left: 10),
  				height: 30,
  				decoration: BoxDecoration(
  					color: UiColors.darkBlueGrey,
  					borderRadius: BorderRadius.circular(30),
  				), // BoxDecoration
  				child: Text(
  					tag, style: TextStyle(
  					color: UiColors.white
  					), // TextStyle
  				) // Text
  		)); // Container
  	}
  	return Row(children: widgetTags);
  }

  Widget _truckDescription() {
    if (truck.description == '') {
      return Container();
    }
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
              children: <Widget>[
                  Expanded(
                   child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _descriptionController,
                    style: TextStyle(
                        color: UiColors.darkSlateBlueTwo,
                        fontSize: 14,
                        fontFamily: 'ProximaNovaBold',
                        letterSpacing: 1),
                  ), // TextFormField
                ), // Container
                Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    '*',
                    style: TextStyle(
                        color: UiColors.illinoisOrange,
                        fontSize: 14,
                        fontFamily: 'ProximaNovaBold'),
                  ),
                ) // Padding
              ],
            ), // Row
      );
  }

  void _saveFoodTruck() {
    updateFoodTruck(truck).then((bool isSuccess) {
      if(isSuccess) {
         Navigator.pushNamed(context, TruckManagementView.id, 
        arguments: truck.username);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: <Widget>[Expanded(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
            	SliverToutHeaderBar(context: context, imageUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',), // SliverToutHeaderBar
            	SliverList(
            		delegate: SliverChildListDelegate(
            			[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
	                                Padding(
	                                    padding:
	                                    EdgeInsets.only(right: 20, left: 20),
	                                    child: Column(
	                                        mainAxisAlignment: MainAxisAlignment.start,
	                                        crossAxisAlignment: CrossAxisAlignment.start,
	                                        children: <Widget>[
	                                          _truckTitle(),
	                                          _truckDetails(),
	                                          _truckDescription(),
	                                        ]
	                                    )),
                              ],
                            ), // Column 
                        ) // Container         
                      ],addSemanticIndexes:false
            		), // SliverChildListDelegate
            	), // SilverList
            ], // silvers
          ), // CustomScrollView
        ) // Container
        ), //Expanded 
        ],
      ), // Column
    ); // Scaffold
  }
}


class _ScheduleDisplayView extends StatelessWidget {
  final String label;
  final GestureTapCallback onTap;

  _ScheduleDisplayView({this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 142,
        decoration: BoxDecoration(
            border: Border.all(color: UiColors.lightPeriWinkle, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                  color: UiColors.darkSlateBlueTwo,
                  fontSize: 16,
                  fontFamily: 'ProximaNovaMedium'),
            ),
            Image.asset('images/icon-down.png')
          ],
        ),
      ),
    );
  }
}

