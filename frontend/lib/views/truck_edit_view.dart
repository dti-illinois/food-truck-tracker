import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config.dart';
import '../models/truck_model.dart';
import '../models/user_model.dart';
import '../secret.dart';
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
  ScrollController _scrollController = ScrollController();
  TimeOfDay startTime;
  TimeOfDay endTime;
  Location location; 
  List<Tag> tags; 
  bool _tagsListVisible = false;

  @override
  void initState() {
    super.initState();
    truck = widget.truck;
    _initElements();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _initElements() {
    startTime = TimeOfDay.fromDateTime(DateTime.parse(truck.schedule.start));
    endTime = TimeOfDay.fromDateTime(DateTime.parse(truck.schedule.end));
    _titleController = TextEditingController(text: truck.displayedName);
    _descriptionController = TextEditingController(text: truck.description);
    tags = List<Tag>.from(truck.tags);
    location = truck.location;
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
  	String locationText =  !location.location_name.isEmpty ? location.location_name : "(${location.lat.toStringAsFixed(1)}, ${location.lng.toStringAsFixed(1)})";
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
                GestureDetector(
                  child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: UiColors.darkSlateBlueTwoTransparent03)
                        ),
                        child: Text("Edit Location"),
                      ),
                  onTap: _onTapEditLocation,
                ),
              ],
            ), // Row
        ); // Padding
  }

  Future<TimeOfDay> _pickTime(TimeOfDay initialTime) async {
    TimeOfDay time =
        await showTimePicker(context: context, initialTime: initialTime);
    return time;
  }

  void _onTapEditLocation() async {
    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: GOOGLE_MAP_API_KEY,   // Put YOUR OWN KEY here.
                            initialPosition: LatLng(LOCATION_LAT, LOCATION_LNG),
                            useCurrentLocation: false,
                            onPlacePicked: (result) {
                              location = new Location(lng: result.geometry.location.lng, lat: result.geometry.location.lat, location_name: result.formattedAddress );
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                          ),
                        ),
                      );

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

void _onTapTag(Tag tag) {
  tags.remove(tag);
  setState(() {});
}

void _onTagListItemTap(Tag tag) {
  tags.add(tag);
  setState(() {});
}

  Widget _truckTagDropdownList() {
    List<Tag> tagsUnselected = Tag.values.where((Tag tag) => !tags.contains(tag)).toList();
    print(tagsUnselected.length);

    return Semantics(
          child:Visibility(
            visible: _tagsListVisible,
            child: Padding(
                padding: EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
                child: Semantics(child:Container(
                  decoration: BoxDecoration(
                    color: UiColors.illinoisOrange,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 2),
                    child: Container(
                      color: Colors.white,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: UiColors.darkSlateBlueTwoTransparent03,
                            ),
                        itemCount: tagsUnselected.length,
                        itemBuilder: (context, index) {
                          return _TagListItemWidget(
                            label: TagHelper.tagToString(tagsUnselected[index]),
                            onTap: () {
                              _onTagListItemTap(tagsUnselected[index]);
                            },
                          );
                        },
                        controller: _scrollController,
                      ),
                    ),
                  ),
                ))),
          ));
  }

  Widget _truckScheduleDetail() {
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

  void _dropdownButtonOnTap() {
    _tagsListVisible = !_tagsListVisible;
    this.setState(() {});
  }

  Widget _truckTags() {
  	List<Widget> widgetTags = [];
  	for(Tag tag in tags) {
  		widgetTags.add(Container(
  				padding: EdgeInsets.symmetric(horizontal: 20),
  				margin: EdgeInsets.only(left: 10),
  				height: 30,
          // width: 40,
  				decoration: BoxDecoration(
  					color: UiColors.darkBlueGrey,
  					borderRadius: BorderRadius.circular(30),
  				), // BoxDecoration
  				child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                Text(
                  TagHelper.tagToString(tag), style: TextStyle(
                  color: UiColors.white
                  ), // TextStyle
                ),  // Text
                SizedBox(width: 10),
                GestureDetector(
                  child: Image.asset('images/icon-x-orange-small.png'),
                  onTap: () => _onTapTag(tag),
                ) // GestureDetector
              ]
            )// Row 
  		)); // Container
  	}
    widgetTags.add(
        GestureDetector(
            child: Padding(child: _tagsListVisible ? Image.asset('images/icon-up.png') : Image.asset('images/icon-down.png'),padding: EdgeInsets.symmetric(horizontal: 3)),
            onTap: _dropdownButtonOnTap,
          )
      );
  	return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap (
                alignment: WrapAlignment.start,
                children: widgetTags,
                runSpacing: 5,
               ),
              _truckTagDropdownList()]);
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

class _TagListItemWidget extends StatelessWidget {
  final String label;
  final GestureTapCallback onTap;

  _TagListItemWidget({this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    TextStyle labelsStyle = TextStyle(fontSize: 16, color: UiColors.darkSlateBlueTwo, fontFamily: 'ProximaNovaMedium');
    bool hasSubLabel = false;
    return Semantics(
        label: label,
        button: true,
        excludeSemantics: true,
        child: InkWell(
            onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: labelsStyle,
                      ), // Text
              ), // Padding
        ) // InkWell
    );
  }
}


