import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:tikal_time_tracker/pages/reset_password/reset_password_presenter.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/pages/reset_password/reset_password_contract.dart';
import 'package:tikal_time_tracker/resources/strings.dart';

class ResetPasswordPage extends StatefulWidget {
  String emailAddress;

  ResetPasswordPage({this.emailAddress});

  @override
  State<StatefulWidget> createState() {
    return ResetPasswordState();
  }
}

class ResetPasswordState extends State<ResetPasswordPage>
    implements ResetPasswordBaseView {
  ResetPasswordPresenter _presenter;
  String _statusText = "";

  @override
  void initState() {
    super.initState();
    _presenter = ResetPasswordPresenter(repository: TimeRecordsRepository());
    _presenter.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: widget.emailAddress);
    emailController.addListener(() {
      print("${emailController.text}");
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
              hintText: Strings.email_hint,
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
              Text(Strings.reset_password_page_title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            ],
          ),
          Container(
            height: 1.5,
            color: Colors.black26,
          )
        ],
      ),
    );

    final resetPasswordButton = AnimationButton(
        buttonText: Strings.reset_password_button_text,
        callback: () {
          _presenter.onResetPasswordButtonClicked(widget.emailAddress);
        });

    final statusField = Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        _statusText,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.red),
        textAlign: TextAlign.start,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      title,
                      emailField,
                      resetPasswordButton,
                      statusField
                    ]))));
  }

  @override
  void handleError() {}

  @override
  void logOut() {}

  @override
  void showResultStatus(String status) {
    setState(() {
      _statusText = status;
    });
  }
}
