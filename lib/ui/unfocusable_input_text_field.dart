import 'package:flutter/material.dart';

class UnFocusableInputTextField extends StatelessWidget {
  final String textValue;
  final String hint;
  final VoidCallback onTap;
  final TextEditingController pickerController = TextEditingController();

  UnFocusableInputTextField({this.textValue, this.hint, this.onTap}){
    pickerController.text = this.textValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: AbsorbPointer(
        absorbing: true,
        child: new TextFormField(
            decoration: InputDecoration(
                labelText: hint ?? "",
                hintText: hint ?? "",
                contentPadding:
                EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
            maxLines: 1,
            controller: pickerController),
      ),
    );
  }
}
