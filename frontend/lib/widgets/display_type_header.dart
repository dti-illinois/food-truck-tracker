/* 
 * Title: Illinois Rokwire Source Code 
 * Author: Illinois Rokwire
 * Date: 2019
 * Availability: https://github.com/rokwire/illinois-client/blob/develop/lib/ui/widgets/ExploreDisplayTypeHeader.dart
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/Utils.dart';
import '../widgets/display_type_tab.dart';
import '../views/search_panel.dart';

enum ListMapDisplayType { List, Map }

class ExploreDisplayTypeHeader extends StatelessWidget {
  final ListMapDisplayType displayType;
  final GestureTapCallback onTapList;
  final GestureTapCallback onTapMap;
  final bool searchVisible;

  ExploreDisplayTypeHeader({this.displayType, this.onTapList, this.onTapMap, this.searchVisible = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        color: UiColors.darkBlueGrey,
        child: Padding(
            padding: EdgeInsets.only(left: 18),
            child: Column(children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  ExploreViewTypeTab(
                    label: 'List',
                    hint: '',
                    iconResource: 'images/icon-list-view.png',
                    selected: (displayType == ListMapDisplayType.List),
                    onTap: onTapList,
                  ),
                  Container(
                    width: 10,
                  ),
                  ExploreViewTypeTab(
                    label: 'Map',
                    hint: '',
                    iconResource: 'images/icon-map-view.png',
                    selected: (displayType == ListMapDisplayType.Map),
                    onTap: onTapMap,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Visibility(
                    visible: searchVisible,
                    child: Semantics(
                      button: true, excludeSemantics: true,
                      label: 'Search',child:
                    IconButton(
                      icon: Image.asset('images/icon-search.png'),
                      onPressed: () {
                        Navigator.pushNamed(context, SearchPanel.id);
                      },
                    ),
                  ))
                ],
              )),
            ])));
  }
}
