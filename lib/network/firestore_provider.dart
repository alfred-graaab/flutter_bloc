import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/models/user_data.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  /// Create new user
  /// [userData]: User data
  Future<void> createNewUser(UserData userData) async {
    assert(userData != null);
    var data = {
      'email': userData.email,
      'image_url': userData.imageUrl != null ? userData.imageUrl : '',
      'jagaapp_token': userData.token,
      'mobile_number': userData.mobileNumber,
      'name': userData.name,
      'is_demo': false,
    };
    return _firestore.collection('users').document(userData.id).setData(data);
  }

  /// Get user details
  /// [uid]: User ID
  Future<UserData> getUserData(String uid) async {
    assert(uid != null);
    DocumentSnapshot snapshot =
        await _firestore.collection('users').document(uid).get();

    if (snapshot.exists) {
      UserData userData = UserData.fromMap(snapshot.data);
      userData.id = snapshot.documentID;
      return userData;
    }
    return null;
  }

  /// Update user details
  /// [uid]: User ID
  /// [data]: Field and value for user detail
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    assert(uid != null && data != null);
    return await _firestore.collection("users").document(uid).updateData(data);
  }
}
