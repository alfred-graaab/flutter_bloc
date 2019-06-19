import 'package:flutter/material.dart';

class MessageData {
  String title;
  String message;
  String navigateTo;
  String popTo;
  String action;
  Map<String, dynamic> data;

  MessageData(
      {@required this.title,
      @required this.message,
      this.navigateTo,
      this.popTo,
      this.action,
      this.data});
}
