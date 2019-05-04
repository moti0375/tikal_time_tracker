
import 'package:tikal_time_tracker/ui/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAppbar extends PlatformWidget{

  final Widget actions;
  final Widget title;

  PlatformAppbar({this.title, this.actions});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoNavigationBar(
      middle: title,
      trailing: actions,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
    return AppBar(
      title: title,
      actions: <Widget>[
        actions
      ],
    );
  }

}