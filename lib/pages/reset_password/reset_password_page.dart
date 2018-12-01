import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';

class ResetPasswordPage extends StatefulWidget {
  String emailAddress;

  ResetPasswordPage({this.emailAddress});

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: widget.emailAddress);
    emailController.addListener(() {
//      print("${emailController.text}");
      widget.emailAddress = emailController.text;
    });

    final emailField = Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: emailController,
          onFieldSubmitted: (value) {
            print("onFieldSubmitted: $value");
            widget.emailAddress = value;
          },
          onEditingComplete: () {},
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0))),
        ));

    final title = Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Password Resetting", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            ],
          ),
          Container(
            height: 1.5,
            color: Colors.black26,
          )
        ],
      ),
    );

    final resetPasswordButton = AnimationButton(buttonText: "Reset password",callback: () {
    });

    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      title,
                      emailField,
                      resetPasswordButton
                    ]))));
  }
}
