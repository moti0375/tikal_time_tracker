import 'package:flutter/material.dart';

class MoreWithRedDotIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(Icons.more_vert),
        Positioned(
          left: 1.0,
          child: Icon(
            Icons.brightness_1,
            color: Colors.red,
            size: 8.0,
          ),
        )
      ],
    );
  }
}
