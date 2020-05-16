import 'package:flutter/material.dart';
import '../utils/Utils.dart';

typedef TimePickedCallback = void Function(TimeOfDay);

class TimestampEditableDisplay extends StatelessWidget {
  final TimeOfDay time;
  final TimePickedCallback onTap;

  TimestampEditableDisplay({this.time, this.onTap});

  void _onTimePicked(BuildContext context) async {
    TimeOfDay initialTime = time?? (new TimeOfDay());
    TimeOfDay newTime =
          await showTimePicker(context: context, initialTime: initialTime);
    onTap(newTime);
  }

  @override
  Widget build(BuildContext context) {
    String label = TimeUtils.formatTimeOfDay(time);
    return GestureDetector(
      onTap: () => _onTimePicked(context),
      child: Container(
        height: 48,
        width: 142,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: UiColors.lightPeriWinkle, width: 1)),
        ), // BoxDecoration
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