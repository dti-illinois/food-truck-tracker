import 'package:flutter/material.dart';
import '../config.dart';
import '../models/truck_model.dart';
import '../services/truck_service.dart';
import '../utils/Utils.dart';
import '../views/truck_detail.dart';
import '../widgets/header_bar.dart';
import '../widgets/truck_card.dart';

class SearchPanel extends StatefulWidget {
  static String id = 'search';
  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {

	TextEditingController _textEditingController = TextEditingController();
	String _searchLabel = 'Searching Trucks';
	int _resultsCount = 0;
	bool _resultsCountLabelVisible = false;
	bool _loading = false;
	List<TruckModel> _trucks;


	@override
	void dispose() {
	_textEditingController.dispose();
	super.dispose();
	}

	@override 
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: SimpleHeaderBarWithBack(
			context: context,
			titleWidget: Text( "Search",
			  style: TextStyle(
			      color: Colors.white,
			      fontSize: 16,
			      fontWeight: FontWeight.w900,
			      letterSpacing: 1.0),
				),
			),
			body: _buildContent(),
			backgroundColor: UiColors.illinoisWhiteBackground,
		);
	}

	Widget _buildContent() {
		return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            	Container(
                padding: EdgeInsets.only(left: 16),
                color: Colors.white,
                height: 48,
                child: Row(
                  children: <Widget>[
                  Flexible(
                      child:
                      Semantics(
                        label: 'Search Input',
                        hint: '',
                        textField: true,
                        excludeSemantics: true,
                  	child: TextField(
                      controller: _textEditingController,
                      onChanged: (text) => _onTextChanged(text),
                      onSubmitted: (_) => _onTapSearch(),
                      autofocus: true,
                      cursorColor: UiColors.illinoisOrange,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ProximaNovaRegular',
                          color: UiColors.greyishBrown),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),// TextField
                    )), // Semanic Flexible
                    Semantics(
                      label: 'Clear',
                      button: true,
                      excludeSemantics: true,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: _onTapClear,
                          child: Image.asset(
                            'images/icon-x-orange.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      )
                    ), // Semantics Clear 
                    Semantics(
                      label: 'Search',
                      button: true,
                      excludeSemantics: true,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: _onTapSearch,
                          child: Image.asset(
                            'images/icon-search.png',
                            color: UiColors.illinoisOrange,
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ), // Semantics Search
                 ]) // Row 
               ), // Container 
               Padding(
                  padding: EdgeInsets.all(16),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 20, color: UiColors.darkSlateBlueTwo),
                      children: <TextSpan>[
                        TextSpan(
                            text: _searchLabel,
                            style: TextStyle(
                              fontFamily: 'ProximaNovaSemiBold',
                            )),
                      ],
                    ),
                  )), // Padding
              Visibility(
                visible: _resultsCountLabelVisible,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                  child: Text(getResultsInfoText(),
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'ProximaNovaRegular',
                        color: UiColors.greyishBrown),
                  ),
                ),
              ), // Visibility
              _buildListViewWidget(),
            ],    
        ));// Column
	}

	  String getResultsInfoText() {
	    if (_resultsCount == 0)
	      return 'No results found';
	    else if (_resultsCount == 1)
	      return '1 result found';
	    else if (_resultsCount > 1)
	      return '${_resultsCount} results found';
	    else
	      return "";
	  }


	Widget _buildListViewWidget() {
		if (_loading) {
		  return Container(
		    child: Align(
		      alignment: Alignment.center,
		      child: CircularProgressIndicator(),
		    ),
		  );
		}
		int trucksCount = (_trucks != null) ? _trucks.length : 0;
		Widget exploresContent;
		if (trucksCount > 0) {
		  exploresContent = ListView.separated(
		    physics: NeverScrollableScrollPhysics(),
		    shrinkWrap: true,
		    separatorBuilder: (context, index) => Divider(
		          color: Colors.transparent,
		        ),
		    itemCount: trucksCount,
		    itemBuilder: (context, i) {
		      	TruckModel truck = _trucks[i];
				return TruckCard(truck: truck, onCardTap: () {_onCardTap(truck);}, isTagsVisible:false);
		    },
		  );
		}
		return exploresContent ?? Container();
	}

	bool _onCardTap(TruckModel truck) {
		Navigator.pushNamed(context, TruckDetailView.id, arguments: TruckDetailArgument(truck, Location(lat:LOCATION_LAT ,lng:LOCATION_LNG)));
	}

	Widget _onTextChanged(String text) {
		_resultsCountLabelVisible = false;
	    setState(() {
	      _searchLabel ='Searching Trucks';
	    });
	}

	void _onTapClear() {
	    if (_textEditingController.text.isEmpty) {
	      Navigator.pop(context);
	      return;
	    }
	    _trucks = null;
	    _textEditingController.clear();
	    _resultsCountLabelVisible = false;
	    setState(() {
	      _searchLabel = 'Searching Trucks';
	    });
	 }

	 void _onTapSearch() {
	    FocusScope.of(context).requestFocus(new FocusNode());
	    _setLoading(true);
	    String searchValue = _textEditingController.text;
	    if (searchValue == "") {
	      return;
	    }
	    _searchTrucks(searchValue);
	  }

	void _setLoading(bool loading) {
	    setState(() {
	      _loading = loading;
	    });
	}

	void _searchTrucks(String keyword) {
	    if (keyword == null) {
	      return;
	    }
	    keyword = keyword.trim();
	    if (keyword == "") {
	      return;
	    }
	    searchTrucks(searchInput: keyword).then((trucks) => _onTrucksSearchFinished(trucks));
	}

	void _onTrucksSearchFinished(List<TruckModel> trucks) {
	    _trucks = trucks;
	    _resultsCount = trucks?.length ?? 0;
	    _resultsCountLabelVisible = true;
	    _searchLabel = 'Results for ' + _textEditingController.text;
	    _setLoading(false);
	}
}