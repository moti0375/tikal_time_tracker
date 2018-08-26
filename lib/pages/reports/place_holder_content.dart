import 'package:flutter/material.dart';

class PlaceholderContent extends StatelessWidget {
  final String title;
  final String subtitle;

  PlaceholderContent(
      {this.title = "No Work On This Period",
      this.subtitle = "Click to add report"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(
            fontSize: 32.0,
            color: Colors.black54
          ),
          textAlign: TextAlign.center),
          Text(subtitle, style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54
          ),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
