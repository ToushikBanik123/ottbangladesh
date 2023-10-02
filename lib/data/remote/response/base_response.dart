

import '../../../constants.dart';

class BaseResponse {
  late bool isSuccessful;
  dynamic data;
  late String message;

  BaseResponse(Map<String, dynamic> json) {
    isSuccessful = json[keySuccess] as bool;
    data = json[keyData];
    message = json[keyMessage] as String? ?? defaultString;
  }
}
