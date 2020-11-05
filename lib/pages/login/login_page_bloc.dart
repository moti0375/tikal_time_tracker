import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tikal_time_tracker/analytics/analytics.dart';
import 'package:tikal_time_tracker/analytics/events/login_event.dart';
import 'package:tikal_time_tracker/pages/bottom_navigation/bottom_navigation.dart';
import 'package:tikal_time_tracker/data/exceptions/failed_login_exception.dart';
import 'package:tikal_time_tracker/data/repository/app_repository.dart';
import 'package:tikal_time_tracker/pages/login/login_event.dart';
import 'package:tikal_time_tracker/pages/login/login_state.dart';
import 'package:tikal_time_tracker/pages/reset_password/reset_password_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';
import 'package:tikal_time_tracker/services/auth/auth.dart';
import 'package:tikal_time_tracker/services/auth/user.dart';
import 'package:tikal_time_tracker/storage/preferences.dart';
import 'package:tikal_time_tracker/utils/page_transition.dart';

class LoginPageBloc {
  BaseAuth _auth;
  Preferences _preferences;
  AppRepository _repository;
  Analytics _analytics;

  LogInModel _currentState = LogInModel();

  LoginPageBloc(
      this._auth, this._preferences, this._repository, this._analytics) {
    _loginEventsController.stream.listen((event) {
      _mapInputEvent(event);
    });
    setInitialState();
  }

  StreamController<LogInModel> _loginStateStreamController =
      StreamController.broadcast();

  Stream<LogInModel> get loginStateStream =>
      _loginStateStreamController.stream.asBroadcastStream();

  Sink<LogInModel> get _loginStateSink => _loginStateStreamController.sink;

  StreamController<LoginPageEvent> _loginEventsController =
      StreamController<LoginPageEvent>();

  Sink<LoginPageEvent> get _loginEventsSink => _loginEventsController.sink;

  void onNewEvent(LoginPageEvent event) {
    _loginEventsSink.add(event);
  }

  void dispose() {
    _loginStateStreamController.close();
    _loginEventsController.close();
  }

  void _mapInputEvent(LoginPageEvent event) {
    print("_mapInputEvent: $event");
    if (event is UserName) {
      _updateUsername(event.userName);
    }

    if (event is Password) {
      _updatePassword(event.password);
    }

    if (event is LoginButtonClicked) {
      _analytics.logEvent(LoginEvent.click(EVENT_NAME.LOGIN_CLICKED).view());
      _startLogin(event.context);
    }

    if (event is ForgotPasswordClicked) {
      _navigateToResetPassword(event);
    }

    if (event is ToggleObscureMode) {
      _toggleObscure();
    }

    if (event is SignOut) {
      _signOut();
    }
  }

  void _updateUsername(String userName) {
    _currentState.updateWith(email: userName);
  }

  void _updatePassword(String password) {
    _currentState.updateWith(password: password);
  }

  void _startLogin(BuildContext context) async {
    _loginStateSink.add(_currentState.updateWith(loggingIn: true, errorInfo: Strings.empty_string));
    _auth.login(_currentState.email, _currentState.password).then(
      (user) {
        if (user != null) {
         _handleLoginSuccess(user, context);
        }
      },
      onError: (e) => _handleLoginError(e),
    );
  }

  void _navigateToTabsScreen(BuildContext context) {
    _repository.timePage().then((response) {
      Navigator.of(context)
          .pushReplacement(PageTransition(widget: BottomNavigation()));
    });
  }

  void setInitialState() async {
    final email = await _preferences.getLoginUserName();
    final password = await _preferences.getLoginPassword();
    print("setInitialState: $email, $password");
    _currentState.updateWith(email: email, password: password);
    _loginStateStreamController.add(_currentState);
  }

  void _navigateToResetPassword(ForgotPasswordClicked forgotPasswordEvent) {
    Navigator.of(forgotPasswordEvent.context).push(PageTransition(
        widget: ResetPasswordPage(emailAddress: _currentState.email)));
  }

  void _toggleObscure() {
    _currentState.toggleObscure();
    _loginStateSink.add(_currentState);
  }

  void _signOut() async {
    _currentState.updateWith(email: Strings.empty_string, password: Strings.empty_string);
    _loginStateSink.add(_currentState);
    _preferences.signOut();
  }

  void _handleLoginSuccess(User user, BuildContext context) {
    _preferences.setLoginUserName(_currentState.email);
    _preferences.setLoginPassword(_currentState.password);
    _analytics.logEvent(LoginEvent.impression(EVENT_NAME.LOGIN_OK)
        .setUser(user.name)
        .view());
    _navigateToTabsScreen(context);
  }

  void _handleLoginError(dynamic e) {
    if (e is AppException) {
      _analytics.logEvent(LoginEvent.click(EVENT_NAME.LOGIN_FAILED)
          .setUser(_currentState.email)
          .setDetails(e.cause)
          .view());
      _loginStateSink
          .add(_currentState.updateWith(loggingIn: false, errorInfo: e.cause));
    } else {
      debugPrint("There was an error: ${e.toString()}");
      _analytics.logEvent(LoginEvent.click(EVENT_NAME.LOGIN_FAILED)
          .setUser(_currentState.email)
          .setDetails(e.toString())
          .view());
      _loginStateSink.add(_currentState.updateWith(
          loggingIn: false, errorInfo: "There was an error"));
    }
  }


}
