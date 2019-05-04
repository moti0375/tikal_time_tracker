import 'package:flutter/material.dart';
import 'dart:async';
class AnimationButton extends StatelessWidget {

  AnimationButton({@required this.buttonText, @required this.onPressed, @required this.loggingIn});
  final VoidCallback onPressed;
  final String buttonText;
  final bool loggingIn;
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _globalKey,
      height: 45.0,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(0.0),
        child: buildButtonChild(),
        onPressed: loggingIn == true ? null : () {
          onPressed();
        },
      ),
    );
  }

  Widget buildButtonChild() {
    if (!loggingIn) {
      return Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else {
      return SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
    }
  }
}
