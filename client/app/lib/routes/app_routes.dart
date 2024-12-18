import 'package:flutter/material.dart';

import 'package:app/screens/login_screen.dart';
import 'package:app/screens/signup_screen.dart';
import 'package:app/screens/introduction_screen.dart';
import 'package:app/screens/logged_in_base_screen.dart';

class AppRoutes {
  static const String introduction = '/introduction';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String loggedIn = '/logged_in';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case introduction:
        return MaterialPageRoute(builder: (_) => IntroductionScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case loggedIn:
        return MaterialPageRoute(builder: (_) => LoggedInBaseScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}')
            ),
          ),
        );
    }
  }
}
