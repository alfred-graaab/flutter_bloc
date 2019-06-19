import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/models/message_data.dart';
import 'package:flutter_bloc/models/user_data.dart';
import 'package:flutter_bloc/network/repository.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:flutter_bloc/utils/util.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final _repository = Repository();
  final _auth = FirebaseAuth.instance;

  final _name = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _countryCode = BehaviorSubject<String>();
  final _mobileNumber = BehaviorSubject<String>();
  final _enableRegisterButton = BehaviorSubject<bool>();
  final _isLoading = BehaviorSubject<bool>();
  final _userData = BehaviorSubject<UserData>();
  final _navigateTo = BehaviorSubject<String>();
  final _showMessage = BehaviorSubject<MessageData>();

  Observable<String> get name => _name.stream.transform(_validateName);
  Observable<String> get email => _email.stream.transform(_validateEmail);
  Observable<String> get password =>
      _password.stream.transform(_validatePassword);
  Observable<String> get mobileNumber =>
      _mobileNumber.stream.transform(_validateMobile);

  Stream<bool> get enableLoginStream => _enableRegisterButton.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<String> get navigateStream => _navigateTo.stream;
  Stream<MessageData> get showMessageStream => _showMessage.stream;

  Function(String) get changeName => _name.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeMobile => _mobileNumber.sink.add;
  Function(String) get changeCountryCode => _countryCode.sink.add;
  Function(UserData) get changeUserData => _userData.sink.add;

  String get getCountryCode => _countryCode.value;
  UserData get userData => _userData.value;

  final _validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.isNotEmpty) {
      sink.add(name);
    } else {
      sink.addError('invalid_name');
    }
  });

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

  final _validateMobile = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink) {
    String trimNumber = number.replaceFirst(RegExp(r'^0+'), '');
    if ((trimNumber.length > 8 && Util.isNumeric(trimNumber)) ||
        trimNumber.isEmpty) {
      sink.add(trimNumber);
    } else {
      sink.addError('invalid_mobile_number');
    }
  });

  void dispose() async {
    await _name.drain();
    _name.close();
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _mobileNumber.drain();
    _mobileNumber.close();
    await _countryCode.drain();
    _countryCode.close();
    await _enableRegisterButton.drain();
    _enableRegisterButton.close();
    await _isLoading.drain();
    _isLoading.close();
    await _userData.drain();
    _userData.close();
    await _navigateTo.drain();
    _navigateTo.close();
    await _showMessage.drain();
    _showMessage.close();
  }

  /// Create new user with email and password
  void createUserWithEmailAndPassword() {
    _isLoading.sink.add(true);
    _auth
        .createUserWithEmailAndPassword(
            email: _email.value, password: _password.value)
        .then((firebaseUser) {
      if (firebaseUser != null) {
        firebaseUser.getIdToken().then((token) {
          final data = {
            'name': _name.value,
            'email': _email.value,
            'mobile_number': _countryCode.value + _mobileNumber.value,
            'image_url': '',
            'jagaapp_token': token,
            'is_demo': false,
          };

          UserData userData = UserData.fromMap(data);
          UserUpdateInfo userUpdateInfo = UserUpdateInfo();

          userData.id = firebaseUser.uid;
          userUpdateInfo.displayName = _name.value;

          firebaseUser.updateProfile(userUpdateInfo);
          _userData.sink.add(userData);
          addNewUser();
        });
      } else {
        _showErrorMessage(null);
      }
    }).catchError((e, _) => _showErrorMessage(e));
  }

  /// Validate email and password.
  /// [name]: User name
  /// [email]: email
  /// [password]: password
  /// [mobileNumber]: Mobile number
  void validateData(
      String name, String email, String password, String mobileNumber) {
    if (name == null ||
        email == null ||
        password == null ||
        mobileNumber == null) {
      _enableRegisterButton.add(false);
    } else {
      _enableRegisterButton.add(name.isNotEmpty &&
          Util.validateEmail(email) &&
          password.length > 5 &&
          Util.isNumeric(mobileNumber) &&
          mobileNumber.length > 8);
    }
  }

  /// Add new user details
  void addNewUser() {
    if (_isLoading.value != true) _isLoading.sink.add(true);

    _repository.createNewUser(userData).whenComplete(() {
      _isLoading.sink.add(false);
      _navigateTo.sink.add(NaviConstant.noProperty);
    }).catchError((e, _) => _showErrorMessage(e));
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
