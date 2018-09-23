import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../data/repository/time_records_repository.dart';
import '../data/user.dart';
import '../data/models.dart';
import 'dart:async';
import '../network/credentials.dart';
import '../storage/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    initPrefs().then((value) {
      String prefsUserName = widget.preferences.getSingInUserName();
      String prefsPassword = widget.preferences.getSingInPassword();
      print("initState: $prefsUserName:$prefsPassword");
      _signIn(prefsUserName, prefsPassword);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${LoginPage.TAG}: build");

    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ));

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final password = TextFormField(
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
            _createUserAndNavigate();
          },
          color: Colors.lightBlueAccent,
          child: Text("Login", style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
        onPressed: () {},
        child:
            Text("Forgot password?", style: TextStyle(color: Colors.black45)));

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
            loginButton,
            SizedBox(height: 8.0),
            forgotLabel
          ],
        ),
      ),
    );
  }

  _createUserAndNavigate() {
    Project lemui =
        new Project(name: "Leumi", tasks: ["Development", "Consulting"]);
    Project gm = new Project(name: "GM", tasks: ["Development", "Consulting"]);
    Project tikal = new Project(name: "Tikal", tasks: [
      "Development",
      "Meeting",
      "Training",
      "Vacation",
      "Accounting",
      "ArmyService",
      "General",
      "Illness",
      "Management"
    ]);

    User.init("Moti Bartov", "User", "Tikal", <Project>[tikal, lemui, gm]);
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new BottomNavigation()));
    print("Button Clicked");
  }

  void _signIn(String userName, String password) {
    repository.updateCredentials(
        new Credentials(signInUserName: userName, signInPassword: password));
    repository.singIn(userName, password).then((value) {
      debugPrint("Got response: ${value.toString()}");
      if (value.toString().contains("401 Unauthorized")) {
        _showSignInDialog();
      } else {
        widget.preferences.setSingInUserName(userName);
        widget.preferences.setSingInPassword(password);
      }
    }).catchError((err) {
      debugPrint("_login: ${err.toString()}");
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
            _signIn(userName, password);
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

  Widget _buildDialogContent() {
    TextEditingController usernameInputController = TextEditingController();
    TextEditingController passwordInputController = TextEditingController();
  }

  Future<Null> initPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    widget.preferences = Preferences.init(preferences);
  }
}
