import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../base/exception/app_exception.dart';
import '../../../constants.dart';
import '../../lib/preference.dart';
import '../text.dart';

class ApiUtil {
  static Dio? globalClient;

  static Future<Map<String, String>> _getOtherCommonHeaders() async {
    HashMap<String, String> headers = HashMap();

    final authToken = PreferenceUtil.on.read<String?>(
      keyAuthToken,
      defaultValue: null,
    );

    if (TextUtil.isNotEmpty(authToken)) {
      headers[HttpHeaders.authorizationHeader] = authToken!;
    }

    return headers;
  }

  static void _handleException(dynamic e) {
    if ((e != null) && (e is DioError) && (e.message!.trim().isNotEmpty)) {
      if (e.error is SocketException) {
        throw AppException("No Internet Connection");
      } else {
        throw AppException(e.message);
      }
    } else {
      throw e;
    }
  }

  static Future<Response> getRequest({
    required String endPoint,
    Dio? client,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options.headers = await _getOtherCommonHeaders();
    }

    try {
      response = await (client ?? globalClient)!.get(
        endPoint,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> postRequest({
    required String endPoint,
    Dio? client,
    Map<String, dynamic>? data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options.headers = await _getOtherCommonHeaders();
    }

    try {
      response = await (client ?? globalClient)!.post(
        endPoint,
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> putRequest({
    required String endPoint,
    Dio? client,
    Map<String, dynamic>? data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options.headers = await _getOtherCommonHeaders();
    }

    try {
      response = await (client ?? globalClient)!.put(
        endPoint,
        data: data,
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static Future<Response> multiPartPostRequest({
    required String endPoint,
    Dio? client,
    required Map<String, dynamic> data,
    bool shouldGetOtherHeaders = false,
  }) async {
    var response;
    var options = Options();

    if (shouldGetOtherHeaders) {
      options.headers = await _getOtherCommonHeaders();
    }

    try {
      response = await (client ?? globalClient)!.post(
        endPoint,
        data: FormData.fromMap(data),
        options: options,
      );
    } on DioError catch (e) {
      _handleException(e);
    } catch (e) {
      _handleException(e);
    }

    return response;
  }

  static String appendPathIntoPostfix(String postFix, String? value) {
    if (value != null && value.trim().isNotEmpty && postFix.trim().isNotEmpty) {
      postFix += ("/" + value);
    }

    return postFix;
  }

  static String appendParamIntoPostfix(
    String path,
    String key,
    String? value, {
    bool isFirstParam = true,
  }) {
    if (value != null) {
      if (isFirstParam) {
        path += "?";
      } else {
        path += "&";
      }

      path += (key + "=" + value);
    }

    return path;
  }

  static Map<String, dynamic> appendParamIntoData(
    Map<String, dynamic> data,
    String key,
    dynamic value,
  ) {
    if (value != null) {
      data[key] = value;
    }

    return data;
  }
}
