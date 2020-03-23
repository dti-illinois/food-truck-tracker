import 'package:flutter/material.dart';
import 'dart:async';
import 'utils/Utils.dart';
import 'display_type_header.dart';
import 'filter_tab.dart';
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
	StreamController<List<TruckModel>> _truckController = StreamController<List<TruckModel>>();

	ListMapDisplayType _displayType = ListMapDisplayType.List;
	List<TruckModel> _trucks = []; 
	Future<List<TruckModel>> _taskLoading;
	List<Filter> _truckFilters; 
	List<String> _filterTagValues;
	List<String> _filterWorkTimeValues;
	bool _filterOptionsVisible; 
	ScrollController _scrollController = ScrollController();


	@override 
	void initState() {
		_initFilters();
		_loadTruckList();
		super.initState();

	}

	void _loadTruckList() {
		bool onlyOpen = _getOnlyOpenFilter(_truckFilters);
		Tag tag = _getTruckTag(_truckFilters);
		_taskLoading = getFoodTruckList(onlyOpen, tag);
		_taskLoading.then((List<TruckModel> trucks) {
				_refresh(() {
					_trucks = trucks;
					_taskLoading = null; 
					_updateTrucksOnMap(_trucks);
				});
		});
	}

	void _updateTrucksOnMap(List<TruckModel> trucks) {
		print("_updateTrucksOnMap is called");
		print(trucks);
		_truckController.add(trucks);
	}

	bool _getOnlyOpenFilter(List<Filter> filters) {
		for (Filter selectedFilter in filters) {
	      if (selectedFilter.type == FilterType.WorkTime) {
	        int index = selectedFilter.firstSelectedIndex;
	        return index == 0;
	      }
	    }
	    return false;
	}

	Tag _getTruckTag(List<Filter> filters) {
		for (Filter selectedFilter in filters) {
	      if (selectedFilter.type == FilterType.Tag) {
	        int index = selectedFilter.firstSelectedIndex;
	        if (index == 0) {
	          return null; //All tag types
	        }
	        return (_filterTagValues.length > index)
	            ? Tag.values[index - 1]
	            : null;
	      }
	    }
	    return null;
	}

	void _initFilters() {
		_filterOptionsVisible = false;
		_truckFilters = [new Filter(type: FilterType.Tag), new Filter(type:FilterType.WorkTime)];
		_filterTagValues = ["All Tags"];
		for(Tag tag in Tag.values) {
			_filterTagValues.add(TagHelper.tagToString(tag));
		}
		_filterWorkTimeValues = ["Is Open Now", "All Food Trucks"];
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
				child: FoodTruckMapView(Location(lat: 40.1129, lng: -88.2262), _truckController.stream), 
		);
	}

	Widget _buildLoadingView() {
		return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            ],
          );
	}

	List<Widget> _buildFilterWidgets() {
		List<Widget> filterTypeWidgets = List<Widget>();

	    for (int i = 0; i < _truckFilters.length; i++) {
	      Filter selectedFilter = _truckFilters[i];
	      List<String> filterValues = _getFilterValuesByType(selectedFilter.type);
	      int filterValueIndex = selectedFilter.firstSelectedIndex;
	      String filterHeaderLabel = filterValues[filterValueIndex];
	      filterTypeWidgets.add(FilterSelectorWidget(
	        label: filterHeaderLabel,
	        active: selectedFilter.active,
	        visible: true,
	        onTap: (){
	          return _onFilterTypeClicked(selectedFilter);},
	      ));
	    }
	    return filterTypeWidgets;
	}

	List<String> _getFilterValuesByType(FilterType filterType) {
		switch(filterType) {
			case FilterType.Tag:
				return _filterTagValues;
			case FilterType.WorkTime:
				return _filterWorkTimeValues;
			default:
				return null; 
		}
	}

	void _onFilterTypeClicked(Filter selectedFilter) {
	    _refresh(() {
	        for (Filter filter in _truckFilters) {
	          if (filter != selectedFilter) {
	            filter.active = false;
	          }
	        }
		    selectedFilter.active = _filterOptionsVisible = !selectedFilter.active;
	    });
	  }

	void _onFilterValueClick(Filter selectedFilter, int index) {
		selectedFilter.selectedIndexes = {index};
		selectedFilter.active = _filterOptionsVisible = !selectedFilter.active;
		_loadTruckList();
	}

	Widget _buildFilterValueContainers() {
		Filter selectedFilter = null; 
		for(Filter filter in _truckFilters) {
			if (filter.active) {
				selectedFilter = filter;
				break;
			}
		}
		if(selectedFilter == null){
			return Container();
		}
		List<String> filterValues = _getFilterValuesByType(selectedFilter.type);
		return Semantics(child:Visibility(
			      visible: _filterOptionsVisible,
			      child: Padding(
			          padding: EdgeInsets.only(left: 16, right: 16, top: 36, bottom: 40),
			          child: Semantics(child:Container(
			            decoration: BoxDecoration(
			              color: UiColors.illinoisOrange,
			              borderRadius: BorderRadius.circular(5.0),
			            ),
			            child: Padding(
			              padding: EdgeInsets.only(top: 2),
			              child: Container(
			                color: Colors.white,
			                child: ListView.separated(
			                  shrinkWrap: true,
			                  separatorBuilder: (context, index) => Divider(
			                        height: 1,
			                        color: UiColors.darkSlateBlueTwoTransparent03,
			                      ),
			                  itemCount: filterValues.length,
			                  itemBuilder: (context, index) {
			                    return FilterListItemWidget(
			                      label: filterValues[index],
			                      selected: (selectedFilter.selectedIndexes != null && selectedFilter.selectedIndexes.contains(index)),
			                      onTap: () {
			                        _onFilterValueClick(selectedFilter, index);
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
			                      children: <Widget>[
			                      SingleChildScrollView(
			                          scrollDirection: Axis.horizontal,
			                          child: Padding(
			                              padding: EdgeInsets.only(
			                                  left: 12, right: 12, bottom: 12),
			                              child: Row(
			                                children: _buildFilterWidgets(),
			                              )),
			                        ),
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
			                    ),  // Column
			                    _buildFilterValueContainers(),
		                  	],
		                ), // Stack 
		        	), // Expanded 
				], 
			), // Column 
		);
	}
}


enum FilterType{Tag, WorkTime}

class Filter{
  FilterType type;
  Set<int> selectedIndexes; 
  bool active; 

  Filter(
      {@required this.type, this.selectedIndexes = const {0}, this.active=false});

  int get firstSelectedIndex {
    if (selectedIndexes == null || selectedIndexes.isEmpty) {
      return -1;
    }
    return selectedIndexes.first;
  }
}