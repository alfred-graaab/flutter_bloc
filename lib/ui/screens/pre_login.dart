import 'package:flutter/material.dart';
import 'package:flutter_bloc/ui/widgets/theme_button.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:flutter_bloc/utils/localizations.dart';

class PreLogin extends StatefulWidget {
  @override
  _PreLoginState createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  @override
  Widget build(BuildContext context) {
    return _background(context);
  }

  ///Background layout
  Widget _background(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg_pre_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _logoImage(),
                _welcomeText(),
                _signUpButton(),
                _loginButton(),
                _orText(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _facebookButton(),
                    _googleButton(),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _descText(),
                      _emailText(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Logo image
  Widget _logoImage() {
    return Padding(
      padding: EdgeInsets.only(
        left: 0.0,
        top: 64.0,
        right: 0.0,
        bottom: 64.0,
      ),
      child: Image.asset('images/logo_prelogin.png'),
    );
  }

  ///Welcome text
  Widget _welcomeText() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          top: 0.0,
          right: 16.0,
          bottom: 0.0,
        ),
        child: Text(
          AppLocalizations.of(context).welcomeDesc,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///Sign up text
  Widget _descText() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          top: 0.0,
          right: 16.0,
          bottom: 0.0,
        ),
        child: Text(
          AppLocalizations.of(context).signUpDesc,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///Sign up text
  Widget _orText() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 32.0,
          top: 16.0,
          right: 32.0,
          bottom: 0.0,
        ),
        child: Text(
          AppLocalizations.of(context).orUpper,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///Email text
  Widget _emailText() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 32.0,
          top: 0.0,
          right: 32.0,
          bottom: 32.0,
        ),
        child: Text(
          "hello@graaab.com",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///Sign up button
  Widget _signUpButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        top: 32.0,
        right: 32.0,
        bottom: 0.0,
      ),
      child: Hero(
        tag: 'sign_up_button',
        child: ThemeButton(
          title: AppLocalizations.of(context).signUpUpper,
          borderRadius: BorderRadius.circular(5.0),
          onPressed: () => Navigator.of(context).pushNamed(NaviConstant.signUp),
        ),
      ),
    );
  }

  ///Login button
  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        top: 16.0,
        right: 32.0,
        bottom: 0.0,
      ),
      child: Hero(
        tag: 'log_in_button',
        child: ThemeButton(
          title: AppLocalizations.of(context).logInWithEmailUpper,
          backgroundColor: Colors.white,
          titleColor: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(5.0),
          onPressed: () => Navigator.of(context).pushNamed(NaviConstant.login),
        ),
      ),
    );
  }

  Widget _facebookButton() {
    return IconButton(
      iconSize: 60.0,
      icon: Image.asset('images/ic_facebook.png'),
      onPressed: () {},
    );
  }

  Widget _googleButton() {
    return IconButton(
      iconSize: 60.0,
      icon: Image.asset('images/ic_google.png'),
      onPressed: () {},
    );
  }
}
