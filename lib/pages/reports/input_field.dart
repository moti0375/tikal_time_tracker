import 'package:flutter/material.dart';



class InputField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputFieldState();
  }
}


class InputFieldState extends State<InputField>{
  @override
  Widget build(BuildContext context) {
    return new TextField(
        decoration: InputDecoration(
            hintText: "Start Date",
            contentPadding:
            EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0))),
        maxLines: 1,
        enabled: false,
    );
  }

}