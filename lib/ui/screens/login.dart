import 'package:flutter/material.dart';
import 'package:flutter_bloc/blocs/login_bloc.dart';
import 'package:flutter_bloc/ui/widgets/input_text_field.dart';
import 'package:flutter_bloc/ui/widgets/loading_dialog.dart';
import 'package:flutter_bloc/ui/widgets/theme_button.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:flutter_bloc/utils/localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _bloc = LoginBloc();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  );
  final focusOutlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
  );

  @override
  void initState() {
    super.initState();

    _bloc.navigateStream.listen((page) {
      if (this.mounted) {
        switch (page) {
          case NaviConstant.signUp:
            Navigator.of(context).pushNamedAndRemoveUntil(page, (_) => false,
                arguments: {'userData': _bloc.userData});
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

    _emailController.addListener(() {
      if (this.mounted) {
        _bloc.validateData(_emailController.text, _passwordController.text);
      }
    });

    _passwordController.addListener(() {
      if (this.mounted) {
        _bloc.validateData(_emailController.text, _passwordController.text);
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg_login.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).helloThere),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: SafeArea(
              child: _background(),
            ),
          ),
          StreamBuilder<bool>(
            stream: _bloc.isLoadingStream,
            initialData: false,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data ? LoadingDialog() : Container();
            },
          ),
        ],
      ),
    );
  }

  ///Background layout
  Widget _background() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _loginDescText(),
                _emailTFF(),
                _passwordTFF(),
                _forgotPasswordButton(),
              ],
            ),
          ),
        ),
        _loginButton(),
      ],
    );
  }

  Widget _loginDescText() {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        top: 32.0,
        right: 32.0,
        bottom: 0.0,
      ),
      child: Text(
        AppLocalizations.of(context).logInWithCredential,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailTFF() {
    return StreamBuilder<String>(
        stream: _bloc.email,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 32.0,
              right: 32.0,
              bottom: 0.0,
            ),
            child: InputTextField(
              controller: _emailController,
              snapshot: snapshot,
              onChanged: _bloc.changeEmail,
              textInputType: TextInputType.emailAddress,
              labelText: AppLocalizations.of(context).email,
            ),
          );
        });
  }

  Widget _passwordTFF() {
    return StreamBuilder<String>(
        stream: _bloc.password,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 16.0,
              right: 32.0,
              bottom: 0.0,
            ),
            child: InputTextField(
              controller: _passwordController,
              snapshot: snapshot,
              onChanged: _bloc.changePassword,
              labelText: AppLocalizations.of(context).password,
              obscureText: true,
            ),
          );
        });
  }

  ///Forgot password button
  Widget _forgotPasswordButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 0.0,
        top: 32.0,
        right: 0.0,
        bottom: 32.0,
      ),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          AppLocalizations.of(context).forgotPasswordQuestion,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        color: Colors.transparent,
        onPressed: () =>
            Navigator.of(context).pushNamed(NaviConstant.forgotPass),
      ),
    );
  }

  ///Login button
  Widget _loginButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableLoginStream,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Hero(
          tag: 'log_in_button',
          child: ThemeButton(
            isEnabled: snapshot.data,
            title: AppLocalizations.of(context).logInUpper,
            onPressed: snapshot.data
                ? () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _bloc.loginWithEmailAndPassword();
                  }
                : null,
          ),
        );
      },
    );
  }

  //Display dialog message
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).keyString(title)),
          content: Text(AppLocalizations.of(context).keyString(message)),
          actions: <Widget>[
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
