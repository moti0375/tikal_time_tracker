import 'package:flutter/material.dart';

class TextLinkItem extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TextLinkItem({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
