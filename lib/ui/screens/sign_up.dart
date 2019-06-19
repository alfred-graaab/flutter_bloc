import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/blocs/sign_up_bloc.dart';
import 'package:flutter_bloc/models/user_data.dart';
import 'package:flutter_bloc/ui/widgets/input_text_field.dart';
import 'package:flutter_bloc/ui/widgets/loading_dialog.dart';
import 'package:flutter_bloc/ui/widgets/theme_button.dart';
import 'package:flutter_bloc/utils/localizations.dart';

class SignUp extends StatefulWidget {
  final UserData userData;

  SignUp({Key key, this.userData}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _bloc = SignUpBloc();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.userData != null) {
      _bloc.changeUserData(widget.userData);
      _passwordController.text = 'default';
      if (widget.userData.email != null && widget.userData.email.isNotEmpty) {
        _emailController.text = widget.userData.email;
      }
      if (widget.userData.name != null && widget.userData.name.isNotEmpty) {
        _nameController.text = widget.userData.name;
      }
    }

    _bloc.navigateStream.listen((page) {
      if (this.mounted) {
        switch (page) {
          default:
            Navigator.of(context).pushReplacementNamed(page);
        }
      }
    });

    _bloc.showMessageStream.listen((messageData) {
      if (this.mounted) {
        _showDialog(
            title: messageData.title,
            message: messageData.message,
            navigateTo: messageData.navigateTo);
      }
    });

    _nameController.addListener(() {
      if (this.mounted) {
        if (_bloc.userData != null) {
          _bloc.userData.name = _nameController.text;
        }
        _bloc.validateData(_nameController.text, _emailController.text,
            _passwordController.text, _mobileController.text);
      }
    });

    _emailController.addListener(() {
      if (this.mounted) {
        if (_bloc.userData != null) {
          _bloc.userData.email = _emailController.text;
        }
        _bloc.validateData(_nameController.text, _emailController.text,
            _passwordController.text, _mobileController.text);
      }
    });

    _passwordController.addListener(() {
      if (this.mounted) {
        _bloc.validateData(_nameController.text, _emailController.text,
            _passwordController.text, _mobileController.text);
      }
    });

    _mobileController.addListener(() {
      if (_bloc.userData != null) {
        _bloc.userData.mobileNumber =
            _bloc.getCountryCode + _mobileController.text;
      }
      if (this.mounted) {
        _bloc.validateData(_nameController.text, _emailController.text,
            _passwordController.text, _mobileController.text);
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
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
              title: Text(AppLocalizations.of(context).signUpUpper),
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
                _nameTFF(),
                _emailTFF(),
                widget.userData == null ? _passwordTFF() : Container(),
                Row(
                  children: <Widget>[
                    _countryCodeButton(),
                    Expanded(
                      child: _mobileTFF(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _registerButton(),
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

  Widget _nameTFF() {
    return StreamBuilder<String>(
        stream: _bloc.name,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 32.0,
              right: 32.0,
              bottom: 0.0,
            ),
            child: InputTextField(
              controller: _nameController,
              snapshot: snapshot,
              onChanged: _bloc.changeName,
              labelText: AppLocalizations.of(context).name,
            ),
          );
        });
  }

  Widget _emailTFF() {
    return StreamBuilder<String>(
        stream: _bloc.email,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 16.0,
              right: 32.0,
              bottom: 0.0,
            ),
            child: InputTextField(
              controller: _emailController,
              snapshot: snapshot,
              onChanged: _bloc.changeEmail,
              textInputType: TextInputType.emailAddress,
              labelText: AppLocalizations.of(context).email,
              enabled: widget.userData == null ||
                  widget.userData.email == null ||
                  widget.userData.email.isEmpty,
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

  Widget _mobileTFF() {
    return StreamBuilder<String>(
        stream: _bloc.mobileNumber,
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              top: 16.0,
              right: 32.0,
              bottom: 32.0,
            ),
            child: InputTextField(
              controller: _mobileController,
              snapshot: snapshot,
              onChanged: _bloc.changeMobile,
              textInputType: TextInputType.phone,
              labelText: AppLocalizations.of(context).phoneNumber,
            ),
          );
        });
  }

  /// Country code button
  Widget _countryCodeButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.0,
        top: 16.0,
        right: 0.0,
        bottom: 32.0,
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: 41.0,
        color: Colors.white,
        child: CountryCodePicker(
          onChanged: (value) {
            _bloc.changeCountryCode(value.dialCode);
          },
          initialSelection: 'MY',
          showCountryOnly: false,
        ),
      ),
    );
  }

  /// Signup button
  Widget _registerButton() {
    return StreamBuilder<bool>(
      stream: _bloc.enableLoginStream,
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Hero(
          tag: 'sign_up_button',
          child: ThemeButton(
            isEnabled: snapshot.data,
            title: AppLocalizations.of(context).registerUpper,
            onPressed: snapshot.data
                ? () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (widget.userData != null) {
                      _bloc.addNewUser();
                    } else {
                      _bloc.createUserWithEmailAndPassword();
                    }
                  }
                : null,
          ),
        );
      },
    );
  }

  //Display dialog message
  void _showDialog({String title, String message, String navigateTo}) {
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
                navigateTo != null
                    ? Navigator.of(context).pushNamed(navigateTo)
                    : Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
