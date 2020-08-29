import 'package:tikal_time_tracker/ui/more_with_red_dot_icon.dart';
import 'package:tikal_time_tracker/ui/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tikal_time_tracker/utils/action_choice.dart';

class PlatformAppbar extends PlatformWidget {
  final List<Choice> actions;
  final Widget title;
  final Function onPressed;
  final bool notificationEnabled;
  final String heroTag;

  PlatformAppbar(
      {this.title,
      this.actions,
      this.onPressed,
      this.notificationEnabled = false, this.heroTag});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    print("Hero tag: $heroTag");
    if (actions != null) {
      print("buildCupertinoAppbar: with actions");
      return CupertinoNavigationBar(
        heroTag: heroTag,
        transitionBetweenRoutes: false,
        middle: title,
        trailing: _buildCupertinoTrailing(context, actions),
      );
    } else {
      print("buildCupertinoAppbar: no actions");
      return CupertinoNavigationBar(
        heroTag: heroTag,
        transitionBetweenRoutes: false,
        middle: title,
      );
    }
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    if (actions != null) {
      return AppBar(title: title, actions: <Widget>[
        PopupMenuButton<Choice>(
          icon: notificationEnabled
              ? MoreWithRedDotIcon()
              : Icon(Icons.more_vert),
          onSelected: onPressed,
          itemBuilder: (BuildContext context) {
            return actions.map((c) {
              return PopupMenuItem<Choice>(
                value: c,
                child: RichText(
                  text: TextSpan(
                    text: c.title,
                    style: DefaultTextStyle.of(context).style,
                      children: c.textSpans
                  ),
                ),
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
                  if (onPressed != null) {
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
        padding: EdgeInsets.all(8),
        child: Text(actions[0].title),
        onPressed: () {
          if (onPressed != null) {
            onPressed(actions[0]);
          }
        },
      );
    } else {
      return CupertinoButton(
          padding: EdgeInsets.all(8),
          child: Text("Menu"),
          onPressed: () => _showSheet(context)
      );
    }
  }
}
