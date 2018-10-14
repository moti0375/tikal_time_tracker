import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../data/repository/time_records_repository.dart';
import '../data/user.dart';
import '../data/models.dart';
import 'dart:async';
import '../network/credentials.dart';
import '../storage/preferences.dart';
import '../ui/animation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ktoast/ktoast.dart';

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

  String _email;
  String _password;



  @override
  void initState() {
    super.initState();
    initPrefs().then((prefs) {
      widget.preferences = prefs;
      _signIn();
      setState(() {
        _email = widget.preferences.getLoginUserName();
        _password = widget.preferences.getLoginPassword();
      });
      print("initState: $_email:$_password");
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.preferences == null) {
      widget.preferences = Preferences();
    }

    TextEditingController emailController = TextEditingController(text: _email);
    emailController.addListener(() {
//      print("${emailController.text}");
      _email = emailController.text;
    });

    TextEditingController passwordController = TextEditingController(text: _password);
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
          child: Image.asset('assets/logo.png'),
        ));


//    if(_email != null && _email.isNotEmpty){
//      emailController.value = TextEditingValue(text: _email);
//    }

    final email = TextFormField(
      controller: emailController,
      onFieldSubmitted: (value) {
        print("onFieldSubmitted: $value");
        _email = value;
      },
      onEditingComplete: () {},
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

//    if(_password != null && _password.isNotEmpty){
//      passwordController.value = TextEditingValue(text: _password);
//    }


    final password = TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            _login(_email, _password);
          },
          color: Colors.lightBlueAccent,
          child: Text("Login", style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
        onPressed: () {
          _showSignOutDialog();
        },
        child: Text("Sign out", style: TextStyle(color: Colors.black45)));

    return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 15.0),
            password,
            SizedBox(height: 24.0),
            AnimationButton(callback: (){
              print("onPressed");
              _login(_email, _password);
            }),
            SizedBox(height: 8.0),
            forgotLabel
          ],
        ),
      ),
    );
  }

  _createUserAndNavigate() {
//    User.init("Moti Bartov", "User", "Tikal", <Project>[tikal, lemui, gm]);
    print("Button Clicked");
  }

  void _navigateToTime() {
     repository.timePage().then((response) {

//      debugPrint("_navigateToTime response: $response");
      User.init(response);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new BottomNavigation()));
    });
  }

  void _login(String email, String password) {
    repository.login(email, password).then((response) {
//      debugPrint("signin response: ${response.toString()}");
      if (response.toString().isEmpty) {
        print("navigating to Time");
        widget.preferences.setLoginUserName(_email);
        widget.preferences.setLoginPassword(_password);
        _navigateToTime();
        showToast(context, "Success", second: 2, position: ToastPosition.bottom);
      } else if (response.toString().contains("Incorrect login or password")) {
        print("Incorrect login or password");
        showToast(context, "Incorrect login or password", second: 2, position: ToastPosition.bottom);
      }
    });
  }

  void _onClickSignIn(String userName, String password) {
    print("_onClickSignIn: $userName:$password");
    widget.preferences.setSingInUserName(userName);
    widget.preferences.setSingInPassword(password);
    _signIn();
  }

  void _signIn() {
    String username = widget.preferences.getSingInUserName();
    String password = widget.preferences.getSingInPassword();

    print("_signIn: $username:$password");

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
    String userName;
    String password;

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
            child: new TextField(
                onChanged: (value) {
                  userName = value;
                },
                decoration: InputDecoration(
                    hintText: "username",
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                maxLines: 1),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 4.0, bottom: 0.0),
            child: new TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                    hintText: "password",
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                maxLines: 1),
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
          Text("Sign In")
        ],
      ),
      content: dialogContent,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            print("Logging in for: $userName : $password");
            _onClickSignIn(userName, password);
            Navigator.pop(context);
          },
          child: Text("OK"),
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
                  Text("Are you sure?"),
                  Text("This will erase your credentials")
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
          Text("Sign Out")
        ],
      ),
      content: dialogContent,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _signIn();
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            widget.preferences.signOut();
            Navigator.pop(context);
            _signIn();
          },
          child: Text("OK"),
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
}
