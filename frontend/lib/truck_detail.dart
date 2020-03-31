import 'package:flutter/material.dart';
import 'header_bar.dart';
import 'truck_model.dart';
import 'truck_service.dart';
import 'user_model.dart';
import 'user_service.dart';
import 'utils/Utils.dart';

class TruckDetailArgument {
  final TruckModel truck;
  final Location center;
  TruckDetailArgument(this.truck, this.center);
}

class TruckDetailView extends StatefulWidget {
  final TruckModel truck;
  Location center;
  TruckDetailView({this.truck, this.center});

  @override
  _TruckDetailState createState() =>
    _TruckDetailState(truck);
}

class _TruckDetailState extends State<TruckDetailView> {
  TruckModel truck;
  _TruckDetailState(this.truck);

  bool _isTruckLoading = false;
  bool _isFavorite;

  @override
  void initState() {
    _isFavorite = User().isFavTruck(widget.truck.username);
    User().registerSubscriberOfFav(() {
      this.setState(() {_isFavorite = User().isFavTruck(widget.truck.username);});
    });
    _loadFoodTruckDetail();
    super.initState();
  }

  void _loadFoodTruckDetail() {
    _isTruckLoading = true;
    getFoodTruck(truck.username).then((TruckModel detailTruck) {
        this.setState(() {
          truck = detailTruck;
          _isTruckLoading = false;
        });
      });
  }

  void _toggleFavTruck() {
      User().toggleFavTruck(truck.username);
  }

   Widget _truckTitle() {
    bool starVisible = true; // TODO: depends on user type
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                truck.displayedName,
                style: TextStyle(
                    fontSize: 24,
                    color: UiColors.darkSlateBlueTwo,
                    letterSpacing: 1),
              ),
            ),
            Visibility(visible: starVisible,child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFavTruck,
                child: Semantics(
                    label: _isFavorite ? 'Remove From Favorites': 'Add To Favorites',
                    button: true,
                    child:Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10), 
                      child: Image.asset(_isFavorite?'images/icon-star-selected.png':'images/icon-star.png')))
            ),),
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
    double distance = LocationUtils.distance(truck.location.lat, truck.location.lng, widget.center.lat, widget.center.lng); 
  	String locationText =  "${distance.toStringAsFixed(1)} mi (${truck.location.lat.toStringAsFixed(1)}, ${truck.location.lng.toStringAsFixed(1)})";
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
            ),
          );
  }

  Widget _truckScheduleDetail() {
  	String displayTime = "${truck.schedule.start} - ${truck.schedule.end}";
  	return Padding(
          padding: EdgeInsets.only(bottom: 11),
          child:Semantics(
            container: true,
          child:Column(
                children: <Widget>[
	              Semantics(
	              excludeSemantics: true,
	              label: displayTime,
	              child:
	                  Row(
	                    crossAxisAlignment: CrossAxisAlignment.center,
	                    children: <Widget>[
	                      Padding(
	                        padding: EdgeInsets.only(right: 10),
	                        child:Image.asset('images/icon-time.png'),),
	                      Expanded(child: Text(displayTime,
		                    style: TextStyle(
		                        fontFamily: 'ProximaNovaMedium',
		                        fontSize: 16,
		                        color: UiColors.bodyText))),
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
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          child: Text(truck.description),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _isTruckLoading? Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            ],
          )
     :  Scaffold(
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

