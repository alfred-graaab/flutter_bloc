class NewVisitorResponse {
  String result;
  String message;
  String status;
  String code;
  String preVisitorId;

  NewVisitorResponse.fromMap(Map<dynamic, dynamic> data)
      : result = data['result'],
        message = data['message'],
        status = data['status'],
        code = data['code'],
        preVisitorId = data['pre_visitor_id'];
}
