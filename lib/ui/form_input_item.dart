import 'package:flutter/material.dart';


class FormInputItem extends StatelessWidget{
  final String title;
  final TextEditingController _controller = TextEditingController();
  final dynamic onChangedTextChangedListener;
  String _text = "";
  final String hint;
  final bool enabled;

  FormInputItem({this.title, this.enabled, this.onChangedTextChangedListener, this.hint}){
    _controller.text = this.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Text("$title :",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold))),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                enabled: enabled,
                onChanged:_onTextChanged,
                controller: _controller,
                decoration: InputDecoration(
                    hintText: hint,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String text){
    this._text = text;
    if(onChangedTextChangedListener != null){
      onChangedTextChangedListener(text);
    }
  }

  String getText(){
    return _text;
  }

  bool isEnabled(){
    return enabled;
  }

}