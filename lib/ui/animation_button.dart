import 'package:flutter/material.dart';

class AnimationButton extends StatelessWidget {
  AnimationButton(
      {@required this.buttonText, this.onPressed,
      this.loggingIn = false});

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Theme.of(context).primaryColor)
        ),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(0.0),
        child: buildButtonChild(),
        onPressed: loggingIn == true
            ? null
            : onPressed,
      ),
    );
  }

  Widget buildButtonChild() {
    if (!loggingIn) {
      return Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontSize: 25.0),
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
