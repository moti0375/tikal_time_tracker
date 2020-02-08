import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_event.dart';
import 'package:tikal_time_tracker/pages/login/login_page_bloc.dart';
import 'package:tikal_time_tracker/pages/login/login_state.dart' as prefix0;
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/locator/locator.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';
import 'package:tikal_time_tracker/ui/animation_button.dart';
import 'package:tikal_time_tracker/ui/platform_alert_dialog.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/resources/strings.dart';

import 'login_state.dart';

class LoginPage extends StatefulWidget {
  static Widget create() {
    return Consumer<BaseAuth>(
      builder: (context, auth, _) => Provider<LoginPageBloc>(
        create: (context) => LoginPageBloc(auth, locator<Preferences>(),
            locator<AppRepository>(), locator<Analytics>()),
        child: Consumer<LoginPageBloc>(
          builder: (context, bloc, _) => LoginPage(bloc: bloc),
        ),
        dispose: (context, bloc) => bloc.dispose(),
      ),
    );
  }

  final LoginPageBloc bloc;
  static final String TAG = "LoginPage";
  static String tag = "LoginPage";

  LoginPage({this.bloc});

  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
//      print("initState: $_email:$_password");
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget _buildEmailInputField() {
    return TextFormField(
      controller: emailController,
      onFieldSubmitted: (value) {
        print("onFieldSubmitted: $value");
        widget.bloc.onNewEvent(UserName(userName: value));
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
  }

  Widget _buildPasswordInputField(prefix0.LogInModel state) {
    return Stack(
      alignment: const Alignment(0.9, 0),
      children: <Widget>[
        TextFormField(
          focusNode: passwordFocusNode,
          textInputAction: TextInputAction.done,
          controller: passwordController,
          onFieldSubmitted: (password) {
            //_login(_email, _password);
            widget.bloc.onNewEvent(Password(password: password));
            widget.bloc.onNewEvent(LoginButtonClicked(context: context));
//            _loginAuth(context, _email, _password);
          },
          obscureText: state.obscured,
          decoration: InputDecoration(
              hintText: Strings.password_hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0))),
        ),
        InkWell(
            child: new Icon(
                state.obscured == true ? Icons.visibility : Icons.visibility_off),
            onTap: () => widget.bloc.onNewEvent(ToggleObscureMode())
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    emailController.addListener(() {
//      print("${emailController.text}");
      widget.bloc.onNewEvent(UserName(userName: emailController.text));
    });

    passwordController.addListener(() {
//      print("${passwordController.text}");
      widget.bloc.onNewEvent(Password(password: passwordController.text));
    });

    print("${LoginPage.TAG}: build");

    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo_no_background.png'),
        ));

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        FlatButton(
          onPressed: () => widget.bloc.onNewEvent(ForgotPasswordClicked(context: context)),
          child: Text(
            Strings.forgot_password,
            style: TextStyle(color: Colors.black45),
          ),
        ),
        FlatButton(
          onPressed: () => _showSignOutDialog(),
          child: Text(
            Strings.sign_out,
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ],
    );

    Widget _loginInfo(prefix0.LogInModel state) {

      return Text(
        state.errorInfo ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    }

    Widget _loginForm(LogInModel state) {
      print(
          "_loginForm: ${state.email}, ${state.password}, ${state.loggingIn}");
      emailController.text = state.email;
      passwordController.text = state.password;
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 8.0),
              _buildEmailInputField(),
              SizedBox(height: 8.0),
              _buildPasswordInputField(state),
              SizedBox(height: 8.0),
              _loginInfo(state),
              SizedBox(height: 8.0),
              AnimationButton(
                  buttonText: Strings.login_button_text,
                  loggingIn: state.loggingIn,
                  onPressed: () => widget.bloc
                      .onNewEvent(LoginButtonClicked(context: context))),
              forgotLabel
            ],
          ),
        ),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<prefix0.LogInModel>(
          initialData: LogInModel(),
          stream: widget.bloc.loginStateStream,
          builder: (context, snapshot) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 8.0),
                      _loginForm(snapshot.data),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _showSignOutDialog() {
    PlatformAlertDialog dialog = PlatformAlertDialog(
      title: Strings.sign_out_approval_title,
      content: Strings.sign_out_approval_subtitle,
      defaultActionText: "OK",
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context),
          child: Text(Strings.cancel),
        ),
        FlatButton(
          onPressed: (){
            widget.bloc.onNewEvent(SignOut());
            Navigator.pop(context);
          },
          child: Text(Strings.ok),
        )
      ],
    );

    dialog.show(context);
  }
}
