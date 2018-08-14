import 'package:flutter/material.dart';
import 'dart:async';

class TimePageTitle extends StatefulWidget{

  final VoidCallback dateSelectedCallback;

  TimePageTitle({this.dateSelectedCallback});

  @override
  State<StatefulWidget> createState() {
    return new TimePageTitleState();
  }
}


class TimePageTitleState extends State<TimePageTitle>{

  DateTime selectedDate = DateTime.now();
  TextEditingController dateInputController = new TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {

    final dateInput = Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("onTap dateInput");
                _showDateDialog();
              },
              child: Icon(Icons.date_range),
            ),
          ),
          Container(
            child: new Flexible(
                child: new TextField(
                    decoration: InputDecoration(hintText: "Date",
                        contentPadding: EdgeInsets.fromLTRB(
                            10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    controller: dateInputController,
                    maxLines: 1)),
          ),
        ],
      ),
    );

    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                dateInput,
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
    );
  }


  Future<Null> _showDateDialog() async {
    final DateTime picked = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(selectedDate.year-1, 1),
        lastDate: DateTime(selectedDate.year, 12));

    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
        dateInputController = new TextEditingController(text: "${picked.day}/${picked.month}/${picked.year}");
      });
    }
  }
}