import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/resources/strings.dart';

class SignupContnet extends StatefulWidget {
  var onUsernameChanged;
  var onPasswordChanged;
  var onSubmitClickListener;

  SignupContnet({this.onUsernameChanged, this.onPasswordChanged, this.onSubmitClickListener});

  @override
  State<StatefulWidget> createState() {
    return SignupContentState();
  }
}

class SignupContentState extends State<SignupContnet>{
  String userName;
  String password;
  TextEditingController usernameInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool obscureText = true;

  @override
  void dispose() {
    super.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    usernameInputController.addListener(() {
      widget.onUsernameChanged(usernameInputController.text);
      userName = usernameInputController.text;
    });

    passwordInputController.addListener(() {
      widget.onPasswordChanged(passwordInputController.text);
      password = passwordInputController.text;
    });

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.0),
      child: ListBody(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 0.0, bottom: 4.0),
            child: new TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: usernameFocusNode,
                onFieldSubmitted: (inputUsername){
                  widget.onUsernameChanged(userName);
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                },
                controller: usernameInputController,
                decoration: InputDecoration(
                    hintText: Strings.username_hint,
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                maxLines: 1),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
            child: Stack(
              alignment: const Alignment(0.9, 0),
              children: <Widget>[
                new TextFormField(
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (inputPassword){
                      if(widget.onSubmitClickListener != null && password.isNotEmpty && userName.isNotEmpty){
                        widget.onSubmitClickListener(userName, this.password);
                      }
                    },
                    focusNode: passwordFocusNode,
                    controller: passwordInputController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                        hintText: Strings.password_hint,
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    maxLines: 1),
                InkWell(child: new Icon(obscureText == true ? Icons.visibility : Icons.visibility_off),
                  onTap: (){
                    _toggleObscureText();
                  },),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

}
