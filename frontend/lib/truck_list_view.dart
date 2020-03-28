import 'package:flutter/material.dart';
import 'truck_card.dart';
import 'truck_model.dart';
import 'truck_service.dart';
import 'utils/Utils.dart';
import 'user_model.dart';

class FoodTruckListView extends StatefulWidget {
  static String id = "foodtrucklistview";
  List<TruckModel> trucks;
  Location center;
  FoodTruckListView(this.trucks, this.center);

  @override
  TruckListState createState() => TruckListState(); 
}

class TruckListState extends State<FoodTruckListView> {

  bool _isListLoading = false; 

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTruckLists() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.transparent,
      ),
      itemBuilder: (context, i) {
      	TruckModel truck = widget.trucks[i];
        return TruckCard(truck: truck, center: widget.center, onCardTap: () {_onCardTap(truck);});
      },
      itemCount: widget.trucks.length,
    );
  }

  void _onCardTap(TruckModel truck) {
  	Navigator.pushNamed(context, 'truck_detail', arguments: truck);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTruckLists(),
     );
  }
}