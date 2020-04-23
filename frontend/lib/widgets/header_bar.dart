/*
* Author: Illinois RokWire
* Year: 2019
* Source: https://github.com/rokwire/illinois-client/blob/develop/lib/ui/widgets/HeaderBar.dart
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../utils/Utils.dart';

class SliverToutHeaderBar extends SliverAppBar {
  final BuildContext context;
  final String imageUrl;
  final GestureTapCallback onBackTap;

  SliverToutHeaderBar(
      {
        @required this.context,
        this.imageUrl,
        this.onBackTap,
        Color backColor = Colors.white,
        Color leftTriangleColor = UiColors.white,
        Color rightTriangleColor = UiColors.mangoTransparent05,
      })
      : super(
      pinned: true,
      floating: false,
      expandedHeight: 200,
      backgroundColor: UiColors.darkSlateBlueTwo,
      flexibleSpace: Semantics(container: true,excludeSemantics: true,child: FlexibleSpaceBar(
          background:
          Container(
            color: backColor,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                imageUrl != '' ?  Positioned.fill(child:Image.network(imageUrl, fit: BoxFit.cover,)) : Container(),
              ],
            ),
          ))
      ),
      leading: Semantics(
          label: 'Back',
          hint:  '',
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: onBackTap != null ? onBackTap : (){
                Navigator.pop(context);
              },
              child: ClipOval(
                child: Container(
                    height: 32,
                    width: 32,
                    color: UiColors.darkSlateBlueTwo,
                    child: Image.asset('images/chevron-left-white.png')
                ),
              ),
            ),
          )
      )
  );
}


// SimpleAppBar

class SimpleHeaderBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final Widget titleWidget;
  final bool backVisible;
  final String backIconRes;
  final Function onBackPressed;
  final bool searchVisible;

  final semanticsSortKey;

  SimpleHeaderBarWithBack({@required this.context, this.titleWidget, this.backVisible = true, this.onBackPressed, this.searchVisible = false, this.backIconRes = 'images/chevron-left-white.png', this.semanticsSortKey = const OrdinalSortKey(1) });

  @override
  Widget build(BuildContext context) {
    return Semantics(sortKey:semanticsSortKey,child:AppBar(
      leading: Visibility(visible: backVisible, child: Semantics(
          label: 'Back',
          button: true,
          excludeSemantics: true,
          child: IconButton(
              icon: Image.asset(backIconRes),
              onPressed: _onTapBack)),),
      title: titleWidget,
      centerTitle: true,
      actions: <Widget>[],
    ));
  }

  void _onTapBack() {
    if (onBackPressed != null) {
      onBackPressed();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
