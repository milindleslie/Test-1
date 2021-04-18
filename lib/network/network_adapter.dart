import 'package:dio/dio.dart';
import 'package:test_app/helpers/shared_preferences.dart';
import 'package:test_app/network/endpoints.dart';
import 'package:test_app/network/exceptions.dart';
import 'package:test_app/network/interceptor.dart';

enum RequestType { get, post, patch, delete }

class NetworkAdapter {
  // Singleton
  static final NetworkAdapter shared = NetworkAdapter._privateConstructor();

  NetworkAdapter._privateConstructor();

  static BaseOptions options = new BaseOptions(
    connectTimeout: 8000,
    receiveTimeout: 10000,
    contentType: Headers.jsonContentType,
    followRedirects: false,
    validateStatus: (status) {
      return status < 500;
    },
  );

  static LogInterceptor logInterceptor = new LogInterceptor(requestHeader: true, requestBody: true, responseBody: true, request: true);

  Future<Response> post({EndPoint endPoint, Map<String, dynamic> params, Map<String, dynamic> queryParams}) async {
    Dio dio = new Dio(options);
    // dio.interceptors.add(logInterceptor);
    dio.interceptors.add(CustomLogInterceptor());

    if (endPoint.shouldAddToken == true) {
      options.headers = {'Authorization': 'Bearer ${await SharedPreferenceHelper.shared.getToken()}'};
    }

    options.headers.addAll({'Content-Type': 'application/json'});
    // if (params != null) {
    //   params["platform"] = Platform.isAndroid ? "android" : "ios";
    // }

    Response response;

    try {
      switch (endPoint.requestType) {
        case RequestType.get:
          response = await dio.get(endPoint.url, queryParameters: params ?? queryParams);
          break;
        case RequestType.post:
          response = await dio.post(endPoint.url, data: params, queryParameters: queryParams);
          break;
        case RequestType.patch:
          response = await dio.patch(endPoint.url, data: params, queryParameters: queryParams);
          break;
        case RequestType.delete:
          response = await dio.delete(endPoint.url, data: params);
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
          throw FetchDataException('Timeout Error\n\n${error.message}');
          break;
        case DioErrorType.RESPONSE:
          response = error.response; // If response is available.
          break;
        case DioErrorType.CANCEL:
          throw FetchDataException('Request Cancelled\n\n${error.message}');
          break;
        case DioErrorType.DEFAULT:
          String message = error.message.contains('SocketException') ? "No Internet Connection" : "Oops, Something went wrong";
          throw FetchDataException('$message\n\n${error.message}');
          break;
      }
    }

    return checkAndReturnResponse(response);
  }

  dynamic checkAndReturnResponse(Response response) {
    String description;

    // App specific handling!
    if (response.data is Map) {
      description = response.data.containsKey('message') ? response.data['message'] : null;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        // Null check for response.data
        if (response.data == null) {
          throw FetchDataException('Returned response data is null : ${response.statusMessage}');
        }

        return response;
      case 400:
        throw BadRequestException(description ?? response.statusMessage);
      case 401:
      case 403:
        throw UnauthorisedException(description ?? response.statusMessage);
      case 404:
        throw NotFoundException(description ?? response.statusMessage);
      case 500:
        throw InternalServerException(description ?? response.statusMessage);
      default:
        throw FetchDataException("Unknown error occured\n\nerror Code: ${response.statusCode}  error: ${description ?? response.statusMessage}");
    }
  }
}
