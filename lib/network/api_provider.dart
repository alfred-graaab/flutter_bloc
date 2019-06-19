import 'package:dio/dio.dart';
import 'package:flutter_bloc/network/response/add_tenant_response.dart';
import 'package:flutter_bloc/network/response/new_visitor_response.dart';
import 'package:flutter_bloc/utils/constants.dart';

class ApiProvider {
  Dio dio = Dio(BaseOptions(
    baseUrl: isProduction
        ? 'https://us-central1-redideas-79527.cloudfunctions.net'
        : 'https://us-central1-graaab-app-staging.cloudfunctions.net/',
    connectTimeout: 20000,
    receiveTimeout: 60000,
  ));

  Future<AddTenantResponse> addJaGaAppTenant(
      String propertyId,
      String unitId,
      String userId,
      int userLevel,
      String newUserId,
      int type,
      int startDate,
      int endDate,
      int reminder) async {
    assert(propertyId != null &&
        unitId != null &&
        userId != null &&
        userLevel != null &&
        newUserId != null &&
        type != null);
    var data = {
      'propertyId': propertyId,
      'unitId': unitId,
      'userId': userId,
      'userLevel': userLevel,
      'newUserId': newUserId,
      'type': type
    };
    if (startDate != null && endDate != null && reminder != null) {
      data['startDate'] = startDate;
      data['endDate'] = endDate;
      data['reminder'] = reminder;
    }
    var response = await dio.post("/jagaAppAddTenant", data: data);
    return AddTenantResponse.fromMap(response.data);
  }

  Future<NewVisitorResponse> createNewVisitor(Map<String, dynamic> data) async {
    var response = await dio.post('/jagaAppCreateNewVisitor', data: data);
    return NewVisitorResponse.fromMap(response.data);
  }
}
