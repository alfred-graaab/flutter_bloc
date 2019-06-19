import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/models/message_data.dart';
import 'package:flutter_bloc/models/user_data.dart';
import 'package:flutter_bloc/network/repository.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:flutter_bloc/utils/util.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _repository = Repository();
  final _auth = FirebaseAuth.instance;

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _enableLoginButton = BehaviorSubject<bool>();
  final _isLoading = BehaviorSubject<bool>();
  final _navigateTo = BehaviorSubject<String>();
  final _showMessage = BehaviorSubject<MessageData>();

  final _userData = BehaviorSubject<UserData>();

  Observable<String> get email => _email.stream.transform(_validateEmail);
  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  Stream<bool> get enableLoginStream => _enableLoginButton.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get navigateStream => _navigateTo.stream;
  Stream<MessageData> get showMessageStream => _showMessage.stream;

  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Util.validateEmail(email) || email.isEmpty) {
      sink.add(email);
    } else {
      sink.addError('invalid_email');
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5 || password.isEmpty) {
      sink.add(password);
    } else {
      sink.addError('invalid_password');
    }
  });

  UserData get userData => _userData.value;

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _enableLoginButton.drain();
    _enableLoginButton.close();
    await _isLoading.drain();
    _isLoading.close();
    await _navigateTo.drain();
    _navigateTo.close();
    await _showMessage.drain();
    _showMessage.close();
    await _userData.drain();
    _userData.close();
  }

  /// Firebase Authenticateion with email and password.
  void loginWithEmailAndPassword() {
    if (_isLoading.value != true) {
      _isLoading.sink.add(true);
    }
    _auth
        .signInWithEmailAndPassword(
            email: _email.value, password: _password.value)
        .then(_getUserData)
        .catchError((e, _) => _showErrorMessage(e));
  }

  /// Get UserData
  /// [user]: FirebaseUser
  /// Error: PlatformException message.
  void _getUserData(FirebaseUser user) {
    _repository.getUserData(user.uid).then((userData) {
      user.getIdToken().then((token) {
        if (userData != null) {
          userData.id = user.uid;
          _updateUserToken(token, userData);
          return;
        }

        /// If user never complete sign up with valid account
        userData = UserData.fromMap({
          'name': user.displayName != null ? user.displayName : '',
          'email': user.email != null ? user.email : '',
          'mobile_number': user.phoneNumber != null ? user.phoneNumber : '',
          'image_url': user.photoUrl != null ? user.photoUrl : '',
          'jagaapp_token': token,
        });
        userData.id = user.uid;
        _userData.sink.add(userData);
        _navigateTo.sink.add(NaviConstant.signUp);
      });
    }).whenComplete(() {
      if (_isLoading.value == true) {
        _isLoading.sink.add(false);
      }
    }).catchError((e, _) => _showErrorMessage(e));
  }

  /// Update firebase token
  /// [token]: Firebase token
  /// [userData]: User Data
  void _updateUserToken(String token, UserData userData) {
    if (token != userData.token) {
      userData.token = token;
      _userData.sink.add(userData);

      _repository.updateUserData(
        userData.id,
        {
          'jagaapp_token': token,
        },
      );
    }
  }

  /// Validate email and password.
  validateData(String email, String password) {
    if (email == null || password == null) {
      _enableLoginButton.add(false);
    } else {
      _enableLoginButton
          .add(Util.validateEmail(email) && (password.length > 5));
    }
  }

  /// Show error message
  /// [e]: PlatformException
  void _showErrorMessage(PlatformException e) {
    if (_isLoading.value == true) {
      _isLoading.sink.add(false);
    }
    _auth.signOut();
    _showMessage.sink.add(MessageData(
        title: 'error',
        message: e is PlatformException ? e.message : 'something_wrong'));
  }
}
