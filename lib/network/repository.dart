import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/models/user_data.dart';
import 'package:flutter_bloc/network/api_provider.dart';
import 'package:flutter_bloc/network/firestore_provider.dart';
import 'package:flutter_bloc/network/response/add_tenant_response.dart';
import 'package:flutter_bloc/network/response/new_visitor_response.dart';

class Repository {
  final _apiProvider = ApiProvider();
  final _firestoreProvider = FirestoreProvider();

  ///****************************
  ///********API Provier*********
  ///****************************

  Future<AddTenantResponse> addJaGaAppTenant(
          {@required String propertyId,
          @required String unitId,
          @required String userId,
          @required int userLevel,
          @required String newUserId,
          @required int type,
          int startDate,
          int endDate,
          int reminder}) =>
      _apiProvider.addJaGaAppTenant(propertyId, unitId, userId, userLevel,
          newUserId, type, startDate, endDate, reminder);

  Future<NewVisitorResponse> createNewVisitor(Map<String, dynamic> data) =>
      _apiProvider.createNewVisitor(data);

  ///****************************
  ///*****Firestore Provier******
  ///****************************

  Future<void> createNewUser(UserData userData) =>
      _firestoreProvider.createNewUser(userData);

  Future<void> updateUserData(String uid, Map<String, dynamic> data) =>
      _firestoreProvider.updateUserData(uid, data);

  Future<UserData> getUserData(String uid) =>
      _firestoreProvider.getUserData(uid);
}
