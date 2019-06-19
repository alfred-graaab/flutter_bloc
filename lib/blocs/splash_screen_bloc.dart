import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/models/message_data.dart';
import 'package:flutter_bloc/models/user_data.dart';
import 'package:flutter_bloc/network/repository.dart';
import 'package:flutter_bloc/utils/constants.dart';
import 'package:rxdart/rxdart.dart';

class SplashScreenBloc {
  final _repository = Repository();
  final _auth = FirebaseAuth.instance;

  final _navigateTo = BehaviorSubject<String>();
  final _showMessage = BehaviorSubject<MessageData>();

  final _userData = BehaviorSubject<UserData>();

  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<MessageData> get showMessageStream => _showMessage.stream;

  UserData get userData => _userData.value;

  void dispose() async {
    await _navigateTo.drain();
    _navigateTo.close();
    await _showMessage.drain();
    _showMessage.close();

    await _userData.drain();
    _userData.close();
  }

  void initData() {
    _getAuthUser().then((authUser) {
      if (authUser == null) {
        _navigateTo.sink.add(NaviConstant.preLogin);
      } else {
        _getUserData(authUser);
      }
    }).catchError((e, _) => _showErrorMessage(e));
  }

  /// Get Firebase authentication user.
  Future<FirebaseUser> _getAuthUser() async {
    return await _auth.currentUser();
  }

  /// Get UserData at [user]. Navigate to LoginScreen if the file could not be found.
  void _getUserData(FirebaseUser user) async {
    _repository.getUserData(user.uid).then((userData) {
      user.getIdToken().then((token) {
        if (userData != null) {
          userData.id = user.uid;
          _userData.sink.add(userData);

          if (token != userData.token) {
            _auth.signOut().whenComplete(() {
              _navigateTo.sink.add(NaviConstant.preLogin);
            });
          }
          return;
        }
        userData = UserData.fromMap({
          'name': user.displayName,
          'email': user.email != null ? user.email : '',
          'mobile_number': user.phoneNumber != null ? user.phoneNumber : '',
          'image_url': user.photoUrl != null ? user.photoUrl : '',
          'jagaapp_token': token,
        });
        userData.id = user.uid;
        _userData.sink.add(userData);
        _navigateTo.sink.add(NaviConstant.signUp);
      });
    }).catchError((e, _) => _showErrorMessage(e));
  }

  void _showErrorMessage(PlatformException e) {
    _showMessage.sink.add(MessageData(
        title: 'error',
        message: e is PlatformException ? e.message : 'something_wrong'));
  }
}
