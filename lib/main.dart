import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/ui/screens/forgot_password.dart';
import 'package:flutter_bloc/ui/screens/login.dart';
import 'package:flutter_bloc/ui/screens/pre_login.dart';
import 'package:flutter_bloc/ui/screens/sign_up.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/ui/screens/splash_screen.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:flutter_bloc/utils/localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'JaGaApp',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Color(
          ColorConstant.primaryColor,
        ),
        primaryColorDark: Color(
          ColorConstant.primaryColorDark,
        ),
      ),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
      ],
      routes: {
        NaviConstant.splashScreen: (context) => SplashScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case NaviConstant.signUp:
            return _signUpNavigation(settings);
            break;
          default:
            return _other(settings);
            break;
        }
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) {
            return SplashScreen();
          },
          settings: settings,
        );
      },
    );
  }

  FadeRoute _signUpNavigation(RouteSettings settings) {
    Map<String, dynamic> arguments = settings.arguments;
    var userData = arguments != null ? arguments['userData'] : null;

    return FadeRoute(
      page: SignUp(
        userData: userData,
      ),
      settings: settings,
    );
  }

  FadeRoute _other(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case NaviConstant.preLogin:
        page = PreLogin();
        break;
      case NaviConstant.login:
        page = Login();
        break;
      case NaviConstant.forgotPass:
        page = ForgotPassword();
        break;
      default:
        page = null;
    }
    return FadeRoute(
      page: page,
      settings: settings,
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;

  FadeRoute({this.page, this.settings})
      : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
