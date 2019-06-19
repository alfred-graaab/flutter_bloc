import 'package:flutter/material.dart';
import 'package:flutter_bloc/blocs/forgot_password_bloc.dart';
import 'package:flutter_bloc/ui/widgets/input_text_field.dart';
import 'package:flutter_bloc/ui/widgets/loading_dialog.dart';
import 'package:flutter_bloc/ui/widgets/theme_button.dart';
import 'package:flutter_bloc/utils/localizations.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _bloc = ForgotPasswordBloc();
  final _emailController = TextEditingController();

  final outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  );
  final focusOutlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
  );

  @override
  void initState() {
    super.initState();

    _bloc.showMessageStream.listen((messageData) {
      if (this.mounted) {
        _showDialog(
            title: messageData.title,
            message: messageData.message,
            popTo: messageData.popTo);
      }
    });

    _emailController.addListener(() {
      if (this.mounted) {
        _bloc.validateData(_emailController.text);
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<bool>(
            stream: _bloc.isLoadingStream,
            initialData: false,
            builder: (context, snapshot) {
              var children = <Widget>[];
              children.add(Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/bg_login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ));
              children.add(Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(AppLocalizations.of(context).forgotPassword),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
                body: SafeArea(
                  child: _background(),
                ),
              ));

              if (snapshot.data) children.add(LoadingDialog());
              
              return Stack(
                children: children,
              );
            }),
      ),
    );
  }

  Widget _background() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              _keyInPassDescText(),
              _emailTFF(),
            ],
          ),
        ),
        _resetButton(),
      ],
    );
  }

  Widget _keyInPassDescText() {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        top: 32.0,
        right: 32.0,
        bottom: 0.0,
      ),
      child: Text(
        AppLocalizations.of(context).forgotPasswordDesc,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
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

  ///Login button
  Widget _resetButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableLoginStream,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return ThemeButton(
          isEnabled: snapshot.data,
          title: AppLocalizations.of(context).resetUpper,
          onPressed: snapshot.data
              ? () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _bloc.resetPassword();
                }
              : null,
        );
      },
    );
  }

  //Display dialog message
  void _showDialog({String title, String message, String popTo}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(AppLocalizations.of(context).keyString(title)),
          content: Text(AppLocalizations.of(context).keyString(message)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(AppLocalizations.of(context).okUpper),
              onPressed: () => popTo != null
                  ? Navigator.popUntil(context, ModalRoute.withName(popTo))
                  : Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
