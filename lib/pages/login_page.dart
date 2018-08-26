import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../data/repository/time_records_repository.dart';
import '../data/user.dart';
import '../data/models.dart';

class LoginPage extends StatefulWidget {
  static String tag = "LoginPage";

  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  TimeRecordsRepository repository = TimeRecordsRepository();

  @override
  Widget build(BuildContext context) {

    final logo = Hero(tag: 'hero',
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
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0)
          )
      ),
    );

    final password = TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0)
          )
      ),
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
          child: Text("Login",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
        onPressed: () {},
        child: Text("Forgot password?", style: TextStyle(color: Colors.black45))
    );


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

  _createUserAndNavigate(){

    Project lemui = new Project(name: "Leumi", tasks: ["Development", "Consulting"]);
    Project gm = new Project(name: "GM", tasks: ["Development", "Consulting"]);
    Project tikal = new Project(name: "Tikal", tasks: ["Development", "Meeting", "Training", "Vacation", "Accounting", "ArmyService", "General", "Illness", "Management"]);

    User.init("Moti Bartov", "User", "Tikal", <Project>[tikal, lemui, gm]);
    Navigator.of(context).
    pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new BottomNavigation()));
    print("Button Clicked");
  }

}