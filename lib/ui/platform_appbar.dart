import 'package:tikal_time_tracker/ui/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';

class PlatformAppbar extends PlatformWidget {
  final List<Choice> actions;
  final Widget title;
  final Function onPressed;

  PlatformAppbar({this.title, this.actions, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    if (actions != null) {
      print("buildCupertinoAppbar: with actions");
      return CupertinoNavigationBar(
        transitionBetweenRoutes: true,
        middle: title,
        trailing: _buildCupertinoTrailing(context, actions),
      );
    } else {
      print("buildCupertinoAppbar: no actions");
      return CupertinoNavigationBar(
        middle: title,
      );
    }
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    if (actions != null) {
      return AppBar(title: title, actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: onPressed,
          itemBuilder: (BuildContext context) {
            return actions.map((c) {
              return PopupMenuItem<Choice>(
                value: c,
                child: Text(c.title),
              );
            }).toList();
          },
        )
      ]);
    } else {
      return AppBar(
        title: title,
      );
    }
  }

  void _showSheet(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
            title: Text("Select an option"),
            actions: actions.map((action) {
              return CupertinoActionSheetAction(
                child: Text(action.title),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  if(onPressed != null){
                    onPressed(action);
//                    Navigator.pop(context);
                  }
                },
              );
            }).toList()));
  }

  Widget _buildCupertinoTrailing(BuildContext context, List<Choice> actions) {
    if (actions.length == 1) {
      return CupertinoButton(
        child: Text(actions[0].title),
        onPressed: () {
          if(onPressed != null){
            onPressed(actions[0]);
          }
        },
      );
    } else {
      return CupertinoButton(
          child: Text("Menu"),
          onPressed: () {
            _showSheet(context);
          });
    }
  }
}
