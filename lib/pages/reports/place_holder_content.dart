import 'package:flutter/material.dart';

class PlaceholderContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  PlaceholderContent(
      {this.title = "No Work On This Period",
      this.subtitle = "Click to add report",
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyle(
              fontSize: 32.0,
              color: Colors.black54
            ),
            textAlign: TextAlign.center),
            GestureDetector(
              onTap: (){
                if(onPressed != null){
                  onPressed();
                }
              },
              child: Text(subtitle, style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54
              ),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
