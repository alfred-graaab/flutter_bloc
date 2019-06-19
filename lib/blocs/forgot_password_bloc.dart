import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/models/message_data.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc {
  final _auth = FirebaseAuth.instance;

  final _email = BehaviorSubject<String>();
  final _enableLoginButton = BehaviorSubject<bool>();
  final _isLoading = BehaviorSubject<bool>();
  final _showMessage = BehaviorSubject<MessageData>();

  Observable<String> get email => _email.stream.transform(_validateEmail);

  Stream<bool> get enableLoginStream => _enableLoginButton.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<MessageData> get showMessageStream => _showMessage.stream;

  Function(String) get changeEmail => _email.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ||
        email.isEmpty) {
      sink.add(email);
    } else {
      sink.addError('invalid_email');
    }
  });

  void dispose() async {
    await _email.drain();
    _email.close();
    await _enableLoginButton.drain();
    _enableLoginButton.close();
    await _isLoading.drain();
    _isLoading.close();
    await _showMessage.drain();
    _showMessage.close();
  }

  /// Validate email
  void validateData(String email) {
    if (email == null) {
      _enableLoginButton.add(false);
    } else {
      _enableLoginButton.add(
          RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email));
    }
  }

  /// Reset password
  void resetPassword() {
    if (_isLoading.value != true) {
      _isLoading.sink.add(true);
    }

    _auth.sendPasswordResetEmail(email: _email.value).then((_) {
      if (_isLoading.value == true) {
        _isLoading.sink.add(false);
      }
      _showMessage.sink.add(MessageData(
          title: 'alert',
          message: 'pass_reset_message',
          popTo: NaviConstant.login));
    }).catchError((e, _) {
      if (_isLoading.value == true) {
        _isLoading.sink.add(false);
      }

      _showMessage.sink.add(MessageData(
          title: 'error',
          message: e is PlatformException ? e.message : 'something_wrong'));
    });
  }
}
