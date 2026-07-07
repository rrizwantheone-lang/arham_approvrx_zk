import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:arham_b2c/api/app_exception.dart';
import 'package:arham_b2c/utility/constants.dart';
import 'package:arham_b2c/utility/preference_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static const int timeOutDuration = 30;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: timeOutDuration),
      // Increase connection timeout
      receiveTimeout: const Duration(seconds: timeOutDuration),
      // Increase receive timeout
      sendTimeout: const Duration(seconds: timeOutDuration),
      responseType: ResponseType.json,
    ),
  );

  //TODO : API CALL GET API
  Future<dynamic> get(String baseUrl) async {
    var uri = Uri.parse(baseUrl);
    try {
      log("API is:$baseUrl");
      log("API Param is: null");
      log("API Token is:${PreferenceUtils.getAuthToken()}");

      var response = await _dio.get(
        baseUrl,
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  //TODO : API CALL GET QUERY API
  Future<dynamic> getQueryParam(
    String baseUrl, {
    Map<String, dynamic>? queryParams,
  }) async {
    var uri = Uri.parse(baseUrl);

    // Append query parameters if they are not null or empty
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    }

    log("API is:$baseUrl");
    log("API Param is:$queryParams");
    log("API Token is:${PreferenceUtils.getAuthToken()}");

    try {
      var response = await _dio.get(
        uri.toString(),
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  //TODO : API CALL FOR FormData POST API
  Future<dynamic> postFormDataPost1(String url, FormData payloadObj) async {
    var uri = Uri.parse(url);
    /*var payload = json.encode(payloadObj);*/
    log("API is: $url");
    log("API Fields: ${payloadObj.fields}");
    //log("API Files: ${payloadObj.files}");
    payloadObj.files.forEach((file) {
      final multipart = file.value;
      log("API File => key: ${file.key}, filename: ${multipart.filename}");
    });
    log("API Token: ${PreferenceUtils.getAuthToken()}");
    try {
      var response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
        data: payloadObj,
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> postFormDataPost(String url, FormData payloadObj) async {
    var uri = Uri.parse(url);
    log("API is: $url");
    log("API Fields: ${payloadObj.fields}");
    //log("API Files: ${payloadObj.files}");
    payloadObj.files.forEach((file) {
      final multipart = file.value;
      log("API File => key: ${file.key}, filename: ${multipart.filename}");
    });
    log("API Token: ${PreferenceUtils.getAuthToken()}");

    try {
      var response = await _dio.post(
        url,
        options: Options(
          headers: {
            //"Authorization": PreferenceUtils.getAuthToken(),
            "Content-Type": "multipart/form-data",
            'x-app-type': 'b2c',
            //'accept': '*/*',
          },
        ),
        data: payloadObj,
      );

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> postFormDataPut(String url, FormData formData) async {
    final uri = Uri.parse(url);

    log("API is: $url");
    log("API Fields: ${formData.fields}");
    log("API Token: ${PreferenceUtils.getAuthToken()}");

    try {
      final response = await _dio.put(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            "x-app-type": "b2c",
            "accept": "*/*",
          },
        ),
      );
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  //TODO : API CALL FOR POST API
  Future<dynamic> post(String url, Map<String, dynamic> requestParam) async {
    var uri = Uri.parse(url);
    log("API is:$url");
    log("API Param is:$requestParam");
    log("API Token is:${PreferenceUtils.getAuthToken()}");
    /*var payload = json.encode(requestParam);*/
    try {
      var response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
        data: requestParam,
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      //return _processResponse(response);
      return response; // Returning the response object, which will contain data such as message, role, tempToken
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> post11(
    String url, [
    Map<String, dynamic>? requestParam,
  ]) async {
    var uri = Uri.parse(url);
    log("API is: $url");
    log("API Param is: ${requestParam ?? {}}");
    log("API Token is: ${PreferenceUtils.getAuthToken()}");

    try {
      var response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
        data: requestParam ?? {}, // If null, send empty map
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      return response;
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> post1(String url, Map<String, dynamic> requestParam) async {
    var uri = Uri.parse(url);
    log("API is:$url");
    log("API Param is:$requestParam");
    String? authToken =
        PreferenceUtils.getAuthToken(); // Ensure this retrieves the token correctly
    log("API Token is:$authToken");
    try {
      var response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": authToken, // Ensure the token is not null
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
        data: requestParam,
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> postQuery(
    String url, {
    Map<String, dynamic>? queryParams,
  }) async {
    var uri = Uri.parse(url);
    log("API is:$url");
    log("API Param is:$queryParams");
    log("API Token is:${PreferenceUtils.getAuthToken()}");

    try {
      var response = await _dio.post(
        uri.toString(), // Use the URI string directly
        queryParameters: queryParams, // Pass query parameters
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
      );
      //.timeout(const Duration(seconds: timeOutDuration));

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> requestParam) async {
    var uri = Uri.parse(url);
    log("API is:$url");
    log("API Param is:$requestParam");
    log("API Token is:${PreferenceUtils.getAuthToken()}");
    /*var payload = json.encode(requestParam);*/
    try {
      var response = await _dio.put(
        url,
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
        data: requestParam,
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      //return _processResponse(response);
      return response; // Returning the response object, which will contain data such as message, role, tempToken
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, dynamic>? queryParams,
  }) async {
    var uri = Uri.parse(url);
    log("API is:$url");
    log("API Param is:$queryParams");
    log("API Token is:${PreferenceUtils.getAuthToken()}");
    /*var payload = json.encode(requestParam);*/
    try {
      var response = await _dio.delete(
        url,
        //queryParameters: queryParams, // Pass query parameters
        options: Options(
          headers: {
            "Authorization": PreferenceUtils.getAuthToken(),
            'x-app-type': 'b2c',
            "Content-Type": "application/json",
            'accept': '*/*',
          },
        ),
        //data: requestParam
      );
      //.timeout(const Duration(seconds: timeOutDuration));
      //return _processResponse(response);
      return response; // Returning the response object, which will contain data such as message, role, tempToken
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  //OTHER
  // ignore: unused_element
  dynamic _processResponse1(response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 401:
      case 403:
        //case 404:
        //PreferenceUtils.clearAllPreferences();
        //PreferenceUtils.setIsLogin(false);
        //Get.offAll(() =>const LoginViewNewScreen());
        throw UnAuthorizedException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 500:
      default:
        throw FetchDataException(
          'Error occurred with code : ${response.statusCode}',
          response.request!.url.toString(),
        );
    }
  }

  // ignore: unused_element
  dynamic handleError1(DioException error) {
    if (error.response != null) {
      if (kDebugMode) {
        print('Error Code: ${error.response?.statusCode}');
        print('Error: ${error.response?.data['message']}');
      }
      switch (error.response!.statusCode) {
        case 400:
          throw BadRequestException(
            error.response!.data.toString(),
            error.requestOptions.uri.toString(),
          );
        case 401:
          throw UnAuthorizedException(
            error.response!.data.toString(),
            error.requestOptions.uri.toString(),
          );
        case 403:
          // Handle Unauthorized error
          // throw UnAuthorizedException(
          //   error.response!.data.toString(),
          //   error.requestOptions.uri.toString(),
          // );
        case 404:
          throw NotFoundException(
            'Resource not found: ${error.response?.data['message']}',
            //error.requestOptions.uri.toString(),
          );
        case 500:
          // Internal server error
          throw FetchDataException(
            'Server error occurred with code: ${error.response!.statusCode}',
            error.requestOptions.uri.toString(),
          );
        default:
          // Handle other HTTP errors
          throw FetchDataException(
            'Error occurred with code: ${error.response!.statusCode}',
            error.requestOptions.uri.toString(),
          );
      }
    } else {
      // Handle network errors or no response
      throw FetchDataException(
        'Error occurred with message: ${error.message}',
        error.requestOptions.uri.toString(),
      );
    }
  }

  dynamic _processResponse(Response response) {
    final uri = response.requestOptions.uri.toString();
    final statusCode = response.statusCode ?? 0;
    final message = response.data['message']?.toString() ?? 'Unexpected error';

    switch (statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(message, uri);
      case 401:
        throw UnAuthorizedException(message, uri);
      case 403:
        //throw UnAuthorizedException(message, uri);
      case 404:
        throw NotFoundException(message, uri);
      case 500:
        throw FetchDataException("Internal Server Error: $message", uri);
      default:
        throw FetchDataException("Unexpected Error: $message", uri);
    }
  }

  dynamic handleError(DioException error) {
    final uri = error.requestOptions.uri.toString();

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message =
          error.response?.data['message']?.toString() ??
          'Unexpected error occurred';

      if (kDebugMode) {
        print('Error Code: $statusCode');
        print('Error Message: $message');
      }

      switch (statusCode) {
        case 400:
          throw BadRequestException(message, uri);
        case 401:
          throw UnAuthorizedException(message, uri);
        case 403:
          //throw UnAuthorizedException(message, uri);
        case 404:
          throw NotFoundException(message, uri);
        case 500:
          throw FetchDataException("Internal Server Error: $message", uri);
        default:
          throw FetchDataException("Unexpected Error: $message", uri);
      }
    } else {
      // Handle timeout or no response (network error)
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        //throw TimeOutException(error.message, uri);
        throw TimeOutException(Constants.timeOutMsg, uri);
      } else if (error.type == DioExceptionType.unknown) {
        throw SocketException(error.message, uri);
      } else {
        throw FetchDataException(error.message, uri);
      }
    }
  }
}
