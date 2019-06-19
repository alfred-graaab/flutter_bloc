import 'package:flutter/material.dart';
import 'package:flutter_bloc/blocs/splash_screen_bloc.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:flutter_bloc/utils/localizations.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _bloc = SplashScreenBloc();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.initData();
    });

    _bloc.navigateToStream.listen((page) {
      if (this.mounted) {
        switch (page) {
          case NaviConstant.signUp:
            Navigator.of(context).pushReplacementNamed(page, arguments: {
              'userData': _bloc.userData,
            });
            break;
          default:
            Navigator.of(context).pushReplacementNamed(page);
        }
      }
    });

    _bloc.showMessageStream.listen((messageData) {
      if (this.mounted) {
        _showDialog(messageData.title, messageData.message);
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _background();
  }

  ///Splash screen background
  Widget _background() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.red),
          child: Center(
            child: Image(
              image: AssetImage('images/logo_splash_screen.png'),
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(AppLocalizations.of(context).okUpper),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
