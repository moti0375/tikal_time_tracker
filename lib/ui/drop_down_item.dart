import 'package:flutter/material.dart';



class DropDownItem<T> extends StatefulWidget{

  List<T> items;
  String value;
  String hint;
  DropDownItem({this.items, this.value, this.hint});

  @override
  State<StatefulWidget> createState() {
    return DropDownItemState<T>();
  }
}

class DropDownItemState<T> extends State<DropDownItem>{

  @override
  Widget build(BuildContext context) {

    print("DropDownItemState: build:");
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black45)),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: DropdownButtonHideUnderline(
          child: new DropdownButton(
              iconSize: 30.0,
              hint: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.hint,
                  style: TextStyle(fontSize: 24.0, color: Colors.black26),
                ),
              ),
              value: widget.value,
              items: widget.items.map((dynamic value) {
                return new DropdownMenuItem<dynamic>(
                  value: value,
                  child: new Text(
                    widget.value,
                    style: TextStyle(fontSize: 24.0),
                  ),
                );
              }).toList(),
              onChanged: (dynamic value) {
                _onProjectSelected(value);
              }),
        )
    );
  }

  void _onProjectSelected(T value) {
    setState(() {
      value = value;
    });
  }

}