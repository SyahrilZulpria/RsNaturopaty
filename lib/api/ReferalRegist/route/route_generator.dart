import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/ReferalRegist/auth/sign_up.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';

class GeneratedRoute {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  static goBack() {
    return navigatorKey.currentState?.pop();
  }

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case Login.routeName:
        return MaterialPageRoute(builder: (_) => const Login());
      case SignUpView.routeName:
        if (arg is String) {
          return MaterialPageRoute(
              builder: (_) => SignUpView(referrarCode: arg));
        }
        return MaterialPageRoute(
            builder: (_) => const SignUpView(
                  referrarCode: '',
                ));

      case NavCustomButton.routeName:
        return MaterialPageRoute(builder: (_) => const NavCustomButton());
      default:
        return _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Page Not Found'),
        ),
      ),
    );
  }
}
