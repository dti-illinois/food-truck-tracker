/*
* Author: Illinois RokWire
* Time: 2019
* Source: https://github.com/rokwire/illinois-client-develop/blob/lib/ui/widgets/Filters.dart
*/

import 'package:flutter/material.dart';
import 'utils/Utils.dart';

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