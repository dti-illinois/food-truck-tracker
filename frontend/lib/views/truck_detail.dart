import 'package:flutter/material.dart';
import '../models/truck_model.dart';
import '../models/user_model.dart';
import '../services/truck_service.dart';
import '../services/user_service.dart';
import '../utils/Utils.dart';
import '../views/truck_direction_map_view.dart';
import '../widgets/header_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';


class TruckDetailArgument {
  final TruckModel truck;
  final Location center;
  TruckDetailArgument(this.truck, this.center);
}

class TruckDetailView extends StatefulWidget {
  static String id = "truck_detail";
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
  bool _isFavoriteVisible;

  @override
  void initState() {
    _isFavoriteVisible = User().userType == UserType.User;
    _isFavorite = _isFavoriteVisible && User().isFavTruck(widget.truck.username);
    User().addListener(userFavSubscriber);
    _loadFoodTruckDetail();
    super.initState();
  }

  @override
  void dispose() {
    User().removeListener(userFavSubscriber);
    super.dispose();
  }

  void userFavSubscriber() {
    this.setState(() {_isFavorite = User().isFavTruck(widget.truck.username);});
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

   void _onLoacationDetailTapped() {
    Navigator.pushNamed(context, MapDirectionView.id, 
      arguments: MapDirectionViewArguments(targetLocation: truck.location));
    //curLocation: new Location(lat: truck.location.lat-.01, lng:truck.location.lng),
   }

   Widget _truckTitle() {
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
                    fontFamily: 'ProximaNovaMedium',
                    color: UiColors.darkSlateBlueTwo,
                    letterSpacing: 1),
              ),
            ),
            Visibility(visible: _isFavoriteVisible, child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFavTruck,
                child: Semantics(
                    label: _isFavorite ? 'Remove From Favorites': 'Add To Favorites',
                    button: true,
                    child:Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: IconButton(
     icon: _isFavorite? Icon(Icons.star):Icon(Icons.star_border),
     color: UiColors.darkBlueGrey,
     onPressed: _toggleFavTruck,
     )))
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

  Widget _truckRating(){
    return Row(
        children: <Widget>[
            Row(
            //mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
              index < 4 ? Icons.star : Icons.star_border,
              color: UiColors.illinoisOrange
              );
              }),
            ),
          Expanded(
            child: FlatButton(
            onPressed: _openAlertBox,
            color: Colors.white,
            child: Text(
              "give a rate",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
    ],
    );
  }

  _openAlertBox() {
    var _rating = 0.0;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Rate",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      //Row(
                          //mainAxisSize: MainAxisSize.min,
                      SmoothStarRating(
                            rating: _rating,
                            size: 30,
                            color: UiColors.illinoisOrange,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                            onRated: (value) {
                              print("rating value -> $value");
                              // print("rating value dd -> ${value.truncate()}");
                            },
                          ),
                        ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  /*Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Add Review",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),*/
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: UiColors.darkBlueGrey,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Rate Product",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _truckLocationDetail() {
    String locationText =  !truck.location.location_name.isEmpty ? truck.location.location_name : "(${truck.location.lat.toStringAsFixed(1)}, ${truck.location.lng.toStringAsFixed(1)})";
    return 
        GestureDetector(
          onTap: _onLoacationDetailTapped,
          child: Padding(
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
          )
        );
  }

  Widget _truckScheduleDetail() {
  	String displayTime = "${TimeUtils.formatTimeOfDay(truck.schedule.start)} - ${TimeUtils.formatTimeOfDay(truck.schedule.end)}";
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
  				child:

          Text(
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
              SliverAppBar(
                snap: true,
                floating: true,
                backgroundColor: const Color(0xFF200087),
                expandedHeight: 300,
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipRRect(
                    //borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                    child: Image.network(
                      "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            	//SliverToutHeaderBar(context: context, imageUrl: 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',), // SliverToutHeaderBar
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
                                            _truckRating(),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 30.0,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onLoacationDetailTapped();
          // Add your onPressed code here!

        },
        child: Icon(Icons.map),
        backgroundColor: UiColors.darkBlueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ); // Scaffold
  }
}

