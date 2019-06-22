import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionText;
  final List<Widget> actions;

  PlatformAlertDialog({@required this.title,
    @required this.content,
    @required this.defaultActionText,
    @required this.actions})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null),
        assert(actions != null) ;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => this,
    )
        : await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions.isEmpty ? _setDefaultAction(context): actions,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions.isEmpty ? _setDefaultAction(context): actions,
    );
  }

  List<Widget> _setDefaultAction(BuildContext context) {
    return [
      PlatformAlertDialogAction(
        child: Text(defaultActionText),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ];
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  PlatformAlertDialogAction({@required this.child, @required this.onPressed})
      : assert(child != null),
        assert(onPressed != null);

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO: implement buildMaterialWidget
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
