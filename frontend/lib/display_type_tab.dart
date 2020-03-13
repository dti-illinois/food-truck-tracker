import 'package:flutter/material.dart';
import 'utils/Utils.dart';


class ExploreViewTypeTab extends StatelessWidget {
  final String label;
  final String hint;
  final String iconResource;
  final GestureTapCallback onTap;
  final bool selected;

  ExploreViewTypeTab(
      {this.label,
      this.iconResource,
      this.onTap,
      this.hint = '',
      this.selected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: label,
        hint: hint,
        button: true,
        selected: selected,
        excludeSemantics: true,
        child:Column(children: <Widget>[
        Expanded(child: Container(),),
        Container(
          //color: Colors.amber,
          decoration: selected ? BoxDecoration(border: Border(bottom: BorderSide(color: UiColors.illinoisOrange,width: 2, style: BorderStyle.solid))) : null,
          child:Padding(padding: EdgeInsets.symmetric(vertical:3, horizontal: 5), child:Column(children: <Widget>[
            Row(children: <Widget>[
              Image.asset(iconResource),
              Container(width: 5,),
              Text(label, style: TextStyle(fontFamily: 'ProximaNovaBold', color: UiColors.white, fontSize: 16),)
            ]),
          ],)
        )),
        Expanded(child: Container(),),
        ],),
    ));
  }
}