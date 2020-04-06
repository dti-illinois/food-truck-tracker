import 'package:flutter/material.dart';

import '../models/truck_model.dart';
import '../models/user_model.dart';
import '../services/truck_service.dart';
import '../utils/Utils.dart';
import '../views/truck_detail.dart';
import '../widgets/truck_card.dart';

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
  	Navigator.pushNamed(context, TruckDetailView.id, arguments: TruckDetailArgument(truck, widget.center));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTruckLists(),
     );
  }
}