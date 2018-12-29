import 'package:flutter/material.dart';
import 'package:tikal_time_tracker/bottom_navigation.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/data/user.dart';
import 'dart:async';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:tikal_time_tracker/pages/reset_password/reset_password_page.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/login_event.dart';
import 'package:tikal_time_tracker/pages/login/singup_dialog_contnet.dart';
import 'package:ktoast/ktoast.dart';
import 'package:tikal_time_tracker/resources/strings.dart';

class LoginPage extends StatefulWidget {
  static final String TAG = "LoginPage";
  static String tag = "LoginPage";
  Preferences preferences;

  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TimeRecordsRepository repository = TimeRecordsRepository.init(
      new Credentials(signInUserName: "", signInPassword: ""));

  Analytics analytics = new Analytics();
  String _email;
  String _password;
  bool _loggingIn = false;
  String loginError = "";

  FocusNode passwordFocusNode;
  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    initPrefs().then((prefs) {
      widget.preferences = prefs;
      _signIn();
      setState(() {
        _email = widget.preferences.getLoginUserName();
        _password = widget.preferences.getLoginPassword();
      });
//      print("initState: $_email:$_password");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.preferences == null) {
      widget.preferences = Preferences();
    }

    TextEditingController emailController = TextEditingController(text: _email);
    emailController.addListener(() {
//      print("${emailController.text}");
      _email = emailController.text;
    });

    TextEditingController passwordController =
        TextEditingController(text: _password);
    passwordController.addListener(() {
//      print("${passwordController.text}");
      _password = passwordController.text;
    });

    print("${LoginPage.TAG}: build");

    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo_no_background.png'),
        )
    );

//    if(_email != null && _email.isNotEmpty){
//      emailController.value = TextEditingValue(text: _email);
//    }

    final email = TextFormField(
      controller: emailController,
      onFieldSubmitted: (value) {
        print("onFieldSubmitted: $value");
        _email = value;
        FocusScope.of(context).requestFocus(passwordFocusNode);
      },
      onEditingComplete: () {},
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: Strings.email_hint,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

//    if(_password != null && _password.isNotEmpty){
//      passwordController.value = TextEditingValue(text: _password);
//    }

    final password = TextFormField(
      focusNode: passwordFocusNode,
      textInputAction: TextInputAction.done,
      controller: passwordController,
      onFieldSubmitted: (password){
        _login(_email, _password);
      },
      obscureText: true,
      decoration: InputDecoration(
          hintText: Strings.password_hint,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              _navigateToResetPassword(_email);
            },
            child: Text(Strings.forgot_password, style: TextStyle(color: Colors.black45))
        ),
        FlatButton(
            onPressed: () {
              _showSignOutDialog();
            },
            child: Text(Strings.sign_out, style: TextStyle(color: Colors.black45))
        ),
      ],
    );

    Widget getLoginInfo() {
      if (_loggingIn) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 15.0,
                height: 15.0,
                child: CircularProgressIndicator(
                    value: null,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
            )
          ],
        );
      } else {
        return Container(
            height: 15,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              loginError,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ));
      }
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                logo,
                SizedBox(height: 8.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 8.0),
                AnimationButton(buttonText: Strings.login_button_text,callback: () {
                  analytics.logEvent(LoginEvent.click(EVENT_NAME.LOGIN_CLICKED).view());
                  _login(_email, _password);
                }),
                forgotLabel,
                getLoginInfo()
              ],
            ),
          )
          ,
        ),
      ),
    );
  }

  void _navigateToTime() {
    repository.timePage().then((response) {
//      debugPrint("_navigateToTime response: $response");
      User.init(response);
      Navigator.of(context).pushReplacement(PageTransition(widget: BottomNavigation()));
    });
  }

  void _navigateToResetPassword(String email) {
    Navigator.of(context).push(PageTransition(widget: ResetPasswordPage(emailAddress: email)));
  }

  void _login(String email, String password) {
    setState(() {
      loginError = "";
      _loggingIn = true;
    });

    repository.login(email, password).then((response) {
//      debugPrint("signin response: ${response.toString()}");
//      setState(() {
//        _loggingIn = false;
//      });

      if (response.toString().isEmpty) {
//        print("navigating to Time");
        widget.preferences.setLoginUserName(_email);
        widget.preferences.setLoginPassword(_password);
        analytics.logEvent(LoginEvent.impression(EVENT_NAME.LOGIN_OK).view());
        _navigateToTime();
      } else if (response.toString().contains("Incorrect login or password")) {
        analytics.logEvent(LoginEvent.impression(EVENT_NAME.LOGIN_FAILED).setDetails("Incorrect username or password").view());
        _updateError(Strings.incorrect_credentials);
      }
    });
  }

  void _updateError(String error) {
   // print("updateError: $error");
    setState(() {
      _loggingIn = false;
      loginError = error;
    });
  }

  void _onClickSignIn(String userName, String password) {
    analytics.logEvent(LoginEvent.click(EVENT_NAME.SIGN_IN_CLICKED).view());
   // print("_onClickSignIn: $userName:$password");
    widget.preferences.setSingInUserName(userName);
    widget.preferences.setSingInPassword(password);
    _signIn();
  }

  void _signIn() {
    String username = widget.preferences.getSingInUserName();
    String password = widget.preferences.getSingInPassword();

   // print("_signIn: $username:$password");

    repository.updateCredentials(
        new Credentials(signInUserName: username, signInPassword: password));
    repository.singIn(username, password).then((value) {
//      debugPrint("Got response: ${value.toString()}");
      if (value.toString().contains("401 Unauthorized")) {
        widget.preferences.signOut();
        _showSignInDialog();
      }
    }).catchError((err) {
//      debugPrint("_login: ${err.toString()}");
      _showSignInDialog();
    });
  }

  Future<Null> _showSignInDialog() async {
    String signInUserName;
    String signInPassword;

    AlertDialog dialog = AlertDialog(
      title: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            width: 24.0,
            height: 24.0,
            child: Image.asset(
              'assets/logo.png',
            ),
          ),
          Text(Strings.sign_in)
        ],
      ),
      content: SignupContnet(onUsernameChanged:(username){
        print("Signin onUsernameChanged: $username");
        signInUserName = username;
      },onPasswordChanged: (password){
        signInPassword = password;
        print("Signin onPasswordChanged: $password");
      },onSubmitClickListener: (username, password){
        signInUserName = username;
        signInPassword = password;
        _onClickSignIn(signInUserName, signInPassword);
        Navigator.pop(context);
      },),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _signIn();
          },
          child: Text(Strings.cancel),
        ),
        FlatButton(
          onPressed: () {
            print("Logging in for: $signInUserName : $signInPassword");
            _onClickSignIn(signInUserName, signInPassword);
            Navigator.pop(context);
          },
          child: Text(Strings.ok),
        )
      ],
    );

    return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Future<Null> _showSignOutDialog() async {
    Widget dialogContent = Container(
      padding: EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 0.0, bottom: 4.0),
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(Strings.sign_out_approval_title),
                  Text(Strings.sign_out_approval_subtitle)
                ],
              ),
            ),
          ),
        ],
      ),
    );

    AlertDialog dialog = AlertDialog(
      title: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            width: 24.0,
            height: 24.0,
            child: Image.asset(
              'assets/logo.png',
            ),
          ),
          Text(Strings.sign_out)
        ],
      ),
      content: dialogContent,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _signIn();
          },
          child: Text(Strings.cancel),
        ),
        FlatButton(
          onPressed: () {
            _signOut();
            Navigator.pop(context);
            _signIn();
          },
          child: Text(Strings.ok),
        )
      ],
    );

    return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Widget _buildDialogContent() {
    TextEditingController usernameInputController = TextEditingController();
    TextEditingController passwordInputController = TextEditingController();
  }

  Future<Preferences> initPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Preferences.init(preferences);
  }

  void _signOut(){
    setState(() {
      _email = "";
      _password = "";
    });
    widget.preferences.signOut();
    User.signOut();
  }
}
