import 'package:flutter/material.dart';
import '../models/truck_model.dart';
import '../utils/Utils.dart';

typedef WeeklyScheduleItemCallbacks = void Function(WeeklyScheduleItem);

class HorizonCalendar extends StatelessWidget {
	
	WeeklySchedule schedule;
	WeeklyScheduleItemCallbacks onTap; 

	HorizonCalendar({@required this.schedule, @required this.onTap});

	static const EdgeInsets _iconPadding = EdgeInsets.only(right: 8);


	Widget _buildTimeWidget(String start, String end) {
		String timeText = "${TimeUtils.formatTimestamp(start)} - ${TimeUtils.formatTimestamp(end)}";
		return Container(
		      child: Row(
		        children: <Widget>[
		        Container(
		        	child:Image.asset('images/icon-time.png'),
		        	height: 20),
		          Padding(
		            padding: _iconPadding,
		          ),
		          Text(timeText, overflow: TextOverflow.ellipsis,
		              maxLines: 1,
		              style: TextStyle(
		                  fontFamily: 'ProximaNovaMedium',
		                  fontSize: 14,
		                  color: UiColors.greyishBrown)),
		        ],
		      ),
		    );
	}

	Widget _buildLocationWidget(String locationName) {
		return locationName == "" ? Container() : Container(
				child: Row(
			        children: <Widget>[
			        Container( child: Image.asset('images/icon-location.png'),height: 20,),
			        Padding(
			            padding: _iconPadding,
			          ),
					Text(locationName, overflow: TextOverflow.ellipsis,
					  maxLines: 1,
					  style: TextStyle(
					      fontFamily: 'ProximaNovaMedium',
					      fontSize: 14,
					      color: UiColors.greyishBrown)),
			        ],
		      )
		);
	}

	List<Widget> _buildCalendarItemWidgets() {
		List<Widget> widgets = [];
		for(WeeklyScheduleItem item in schedule.scheduleItems) {
			Widget widget = InkWell(
				onTap: () => onTap(item),
				child: Container(
				margin: EdgeInsets.symmetric(horizontal: 4),
				padding: EdgeInsets.all(3),
				decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(
              color: UiColors.illinoisOrange, width: 1)),
					child: Padding( 
						padding: EdgeInsets.all(3),
						child: Column(
						  			crossAxisAlignment: CrossAxisAlignment.start,
									children: <Widget>[
										Text(item.weekday, style: TextStyle(fontSize: 20, color: UiColors.darkSlateBlueTwo, fontFamily: 'ProximaNovaExtraBold')),
										_buildTimeWidget(item.start, item.end),
										_buildLocationWidget(item.location.location_name),
									],
								) // Column
						)// Padding
				)// Container
			); // InkWell
			widgets.add(widget);
		}
		return widgets;
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
				scrollDirection: Axis.horizontal,
				child: Padding(
				  padding: EdgeInsets.only(
				      left: 12, right: 12, bottom: 12),
				  child: Row(
				    children: _buildCalendarItemWidgets(),
				  )),
				);
	}
}