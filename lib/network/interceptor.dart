import 'package:dio/dio.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    consoleLog('--------------------------------------------------------');
    consoleLog(options.method + " " + options.baseUrl + options.path);
    consoleLog('--------------------------------------------------------');
    consoleLog('HEADER: ' + options.headers.toString());
    if (options.queryParameters != null && options.queryParameters.isNotEmpty) {
      consoleLog('--------------------------------------------------------');
      consoleLog('Query Params: ' + options.queryParameters.toString());
    }
    if (options.data != null) {
      consoleLog('--------------------------------------------------------');
      consoleLog('Request Body: ' + options.data.toString());
    }
  }

  @override
  Future onResponse(Response response) async {
    consoleLog('--------------------------------------------------------');
    consoleLog('STATUS: ' + response.statusCode.toString() + ' ' + response.statusMessage);
    consoleLog('--------------------------------------------------------');
    consoleLog(response.toString());
  }

  @override
  Future onError(DioError err) async {
    consoleLog('--------------------------------------------------------');
    consoleLog('Dio Error: ' + err.type.toString());
    consoleLog('--------------------------------------------------------');
    consoleLog(err.response.toString());
  }

  void consoleLog(String s) {
    if (s == null || s.length <= 0) return;
    const int n = 1000;
    int startIndex = 0;
    int endIndex = n;
    while (startIndex < s.length) {
      if (endIndex > s.length) endIndex = s.length;
      print(s.substring(startIndex, endIndex));
      startIndex += n;
      endIndex = startIndex + n;
    }
  }
}
