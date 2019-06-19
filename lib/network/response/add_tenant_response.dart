class AddTenantResponse {
  String result;
  String message;
  String tenandId;
  int status;

  AddTenantResponse.fromMap(Map<dynamic, dynamic> data)
      : result = data['result'],
        message = data['message'],
        tenandId = data['tenant_id'],
        status = data['status'];
}
