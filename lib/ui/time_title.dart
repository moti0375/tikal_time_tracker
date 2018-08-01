import 'package:flutter/material.dart';

class TimePageTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Text("Time: 31-07-2018", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 200.0, bottom: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          print("Open Date picker");
                        },
                        child: Icon(Icons.date_range),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1.5,
                  color: Colors.black26,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Text("Moti Bartov, User, Tikal"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}