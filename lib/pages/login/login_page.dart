import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/bottom_navigation.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/repository/time_records_repository.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'dart:async';
import 'package:tikal_time_tracker/network/credentials.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikal_time_tracker/ui/platform_alert_dialog.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';
import 'package:tikal_time_tracker/pages/reset_password/reset_password_page.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/login_event.dart';
import 'package:tikal_time_tracker/resources/strings.dart';

class LoginPage extends StatefulWidget {
  static final String TAG = "LoginPage";
  static String tag = "LoginPage";

  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  TimeRecordsRepository repository = TimeRecordsRepository.init(
      new Credentials(signInUserName: "", signInPassword: ""));

  Analytics analytics = new Analytics();
  String _email;
  String _password;
  bool _loggingIn = false;
  String loginError = "";
  bool obscureText = true;

  Preferences preferences;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    preferences = Preferences();
    passwordFocusNode = FocusNode();
    initLoginPage();
//      print("initState: $_email:$_password");
  }

  void initLoginPage() async {
    preferences = await initPrefs();
    String email = await preferences.getLoginUserName();
    String password = await preferences.getLoginPassword();
    setState(() {
      _email = email;
      _password = password;
    });

  }

  @override
  Widget build(BuildContext context) {
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
        ));

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

    final password = Stack(
      alignment: const Alignment(0.9, 0),
      children: <Widget>[
        TextFormField(
          focusNode: passwordFocusNode,
          textInputAction: TextInputAction.done,
          controller: passwordController,
          onFieldSubmitted: (password) {
            //_login(_email, _password);
            _loginAuth(context, _email, _password);
          },
          obscureText: obscureText,
          decoration: InputDecoration(
              hintText: Strings.password_hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0))),
        ),
        InkWell(
            child: new Icon(
                obscureText == true ? Icons.visibility : Icons.visibility_off),
            onTap: () {
              _toggleObscureText();
            }),
      ],
    );


    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              _navigateToResetPassword(_email);
            },
            child: Text(Strings.forgot_password,
                style: TextStyle(color: Colors.black45))),
        FlatButton(
            onPressed: () {
              _showSignOutDialog();
            },
            child: Text(Strings.sign_out,
                style: TextStyle(color: Colors.black45))),
      ],
    );

    Widget getLoginInfo() {
      return SizedBox(
          height: 15,
          child: Text(
            loginError,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ));
    }

    Widget _loginForm() {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 8.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 8.0),
              getLoginInfo(),
              SizedBox(height: 8.0),
              AnimationButton(
                  buttonText: Strings.login_button_text,
                  loggingIn: _loggingIn,
                  onPressed: () {
//                    Navigator.of(context).pop(); // Close keyboard
                    print("onPressed: logging in..");
                    analytics.logEvent(
                        LoginEvent.click(EVENT_NAME.LOGIN_CLICKED).view());
                    _loginAuth(context, _email, _password);
                  }),
              forgotLabel
            ],
          ),
        ),
      );
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                logo,
                SizedBox(height: 8.0),
                _loginForm(),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTabsScreen() {
    repository.timePage().then((response) {
//      debugPrint("_navigateToTime response: $response");
      User.init(response);
      Navigator.of(context)
          .pushReplacement(PageTransition(widget: BottomNavigation()));
    });
  }

  void _navigateToResetPassword(String email) {
    Navigator.of(context)
        .push(PageTransition(widget: ResetPasswordPage(emailAddress: email)));
  }

//  void _login(String email, String password) async {
//    setState(() {
//      loginError = "";
//      _loggingIn = true;
//    });
//
//    String signInUsername = email.split("@")[0];
//    String signInPassword = "${signInUsername}tik23";
//
//    bool signInPassed = await _signIn(signInUsername, signInPassword);
//
//    if(signInPassed){
//      repository.login(email, password).then((response) {
////      debugPrint("signin response: ${response.toString()}");
////      setState(() {
////        _loggingIn = false;
////      });
//
//        if (response.toString().isEmpty) {
////        print("navigating to Time");
//          preferences.setLoginUserName(_email);
//          preferences.setLoginPassword(_password);
//          analytics.logEvent(LoginEvent.impression(EVENT_NAME.LOGIN_OK).view());
//          _navigateToTabsScreen();
//        } else if (response.toString().contains("Incorrect login or password")) {
//          analytics.logEvent(LoginEvent.impression(EVENT_NAME.LOGIN_FAILED)
//              .setDetails(Strings.incorrect_credentials)
//              .view());
//          _updateError(Strings.incorrect_credentials);
//        }
//      }, onError: (e){
//        _updateError(Strings.login_failure);
//      });
//    } else {
//      _updateError("Failed to signin");
//    }
//
//  }

  void _loginAuth(BuildContext context, String email, String password) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    print("loginAuth: called");
    BaseAuth auth = Provider.of<BaseAuth>(context);
    setState(() {
      loginError = "";
      _loggingIn = true;
    });
    auth.login(email, password).then((user){
      if(user != null){
        print("_loginAuth: User: ${user.name}");
        preferences.setLoginUserName(_email);
        preferences.setLoginPassword(_password);
        analytics.logEvent(LoginEvent.impression(EVENT_NAME.LOGIN_OK).view());
        _navigateToTabsScreen();
      } else {
        print("_loginAuth: user null");
      }
    }, onError: (e){
      if(e is FailedLoginException){
        print("_loginAuth: ${e.cause}");
        _updateError(e.cause);
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



  void _showSignOutDialog()  {
    PlatformAlertDialog dialog = PlatformAlertDialog(
      title: Strings.sign_out_approval_title,
      content: Strings.sign_out_approval_subtitle,
      defaultActionText: "OK",
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(Strings.cancel),
        ),
        FlatButton(
          onPressed: () {
            _signOut();
            Navigator.pop(context);
          },
          child: Text(Strings.ok),
        )
      ],
    );

    dialog.show(context);
  }

  Future<Preferences> initPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Preferences.init(preferences);
  }

  void _signOut() {
    setState(() {
      _email = "";
      _password = "";
    });
    preferences.signOut();
    User.signOut();
  }

  void _toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
