/*
* Author: Illinois RokWire
* Time: 2019
* Source: https://github.com/rokwire/illinois-client-develop/blob/lib/ui/widgets/Filters.dart
*/

import 'package:flutter/material.dart';
import '../utils/Utils.dart';

class FilterListItemWidget extends StatelessWidget {
  final String label;
  final String subLabel;
  final GestureTapCallback onTap;
  final bool selected;

  FilterListItemWidget({@required this.label, this.subLabel, @required this.onTap, this.selected = false});

  @override
  Widget build(BuildContext context) {
    TextStyle labelsStyle = TextStyle(fontSize: 16, color: UiColors.darkSlateBlueTwo, fontFamily: (selected ? 'ProximaNovaBold' : 'ProximaNovaMedium'));
    bool hasSubLabel = false;
    return Semantics(
        label: label,
        button: true,
        selected: selected,
        excludeSemantics: true,
        child: InkWell(
            onTap: onTap,
            child: Container(
              color: (selected ? UiColors.illinoisWhiteBackground : Colors.white),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: labelsStyle,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    hasSubLabel
                        ? Text(
                            subLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: labelsStyle,
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset((selected ? 'images/icon-selected.png' : 'images/icon-unselected.png')),
                    )
                  ],
                ),
              ),
            )));
  }
}
class FilterSelectorWidget extends StatelessWidget {
  final String label;
  final String hint;
  final String labelFontFamily;
  final double labelFontSize;
  final bool active;
  final EdgeInsets padding;
  final bool visible;
  final GestureTapCallback onTap;

  FilterSelectorWidget(
      {@required this.label,
        this.hint,
        this.labelFontFamily = 'ProximaNovaBold',
        this.labelFontSize = 16,
        this.active = false,
        this.padding = const EdgeInsets.only(left: 4, right: 4, top: 12),
        this.visible = false,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Semantics(
            label: label,
            hint: hint,
            excludeSemantics: true,
            button: true,
            child: InkWell(
                onTap: onTap,
                child: Container(
                  child: Padding(
                    padding: padding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          label,
                          style: TextStyle(
                              fontSize: labelFontSize, color: (active ? UiColors.illinoisOrange : UiColors.darkSlateBlueTwo), fontFamily: labelFontFamily),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Image.asset(active ? 'images/icon-up.png' : 'images/icon-down.png'),
                        )
                      ],
                    ),
                  ),
                ))));
  }
}