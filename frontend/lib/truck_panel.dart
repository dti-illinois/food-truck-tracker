import 'package:flutter/material.dart';
import 'utils/Utils.dart';
import 'display_type_header.dart';
import 'truck_list_view.dart';
import 'truck_map_view.dart';
import 'truck_model.dart';
import 'truck_service.dart';

class _PanelData {
  TruckPanelState         _panelState;
  bool                    _showHeaderBack;
  bool                    _showTabBar;
}


class TruckPanel extends StatefulWidget {
	_PanelData _data = _PanelData(); 

	@override
	TruckPanelState createState() {
		return _data._panelState = TruckPanelState();
	}
}

class TruckPanelState extends State<TruckPanel> {
	ListMapDisplayType _displayType = ListMapDisplayType.List;
	List<TruckModel> _trucks = []; 
	Future<List<TruckModel>> _taskLoading;

	@override 
	void initState() {
		_taskLoading = getFoodTruckList();
		_taskLoading.then((List<TruckModel> trucks) {
				_refresh(() {
					_trucks = trucks;
					_taskLoading = null; 
				});
		});
		super.initState();

	}

	void _selectDisplayType (ListMapDisplayType displayType) {
		if (_displayType != displayType) {
			_refresh(() {
				_displayType = displayType;
		        _enableMap(_displayType == ListMapDisplayType.Map);
			});    
	    }
	}

	void _refresh(Function fn){
	    this.setState(fn);
	 }

	void _enableMap(bool enable) {
	    
  	}

	Widget _buildListView() {
		if(_taskLoading != null) {
			return _buildLoadingView(); 
		}
		return Visibility(
		    visible: (_displayType == ListMapDisplayType.List),
		    child: Container(
		        color: UiColors.illinoisWhiteBackground, child: FoodTruckListView(_trucks)));
	}

	Widget _buildMapView() {
		if(_taskLoading != null) {
			return _buildLoadingView(); 
		}
		return Container(
				child: FoodTruckMapView(Location(lat: 40.1129, lng: -88.2262), _trucks)
		);
	}

	Widget _buildLoadingView() {

	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Food Truck Tracker"),
			), // appBar 
			body: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					ExploreDisplayTypeHeader(
		              displayType: _displayType,
		              searchVisible: false, // TODO: set as true 
		              onTapList: () => _selectDisplayType(ListMapDisplayType.List),
		              onTapMap: () => _selectDisplayType(ListMapDisplayType.Map),
		            ), // ExploreDisplayTypeHeader
					Expanded(
		                child: Stack(
		                  	children: <Widget>[
			                    Column(
			                      crossAxisAlignment: CrossAxisAlignment.start,
			                        // TODO: Add filters here later 
			                      children: <Widget>[
			                      		Expanded(
			                            child: Container(
			                          	color: UiColors.illinoisWhiteBackground,
			                          	child: Center(
			                            child: Stack(
			                              children: <Widget>[
			                              	_buildMapView(), 
			                                _buildListView(),
			                              ],
			                            ), // Stack 
			                          	), // Center 
			                        	) // Container 
			                        	) // Expanded
			                        ],
			                    ) // Column
		                  	],
		                ), // Stack 
		        	), // Expanded 
				], 
			), // Column 
		);
	}
}