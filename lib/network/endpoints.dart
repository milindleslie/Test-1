import 'package:test_app/resources/constants.dart';

import 'network_adapter.dart';

enum EndPoint { getHomeFeed }

extension URLExtenssion on EndPoint {
  static final String _baseUrl = AppConstants.baseURL;

  String get url {
    switch (this) {
      case EndPoint.getHomeFeed:
        return _baseUrl + '/homeFeed';
      default:
        throw Exception(["Endpoint not defined"]);
        return null;
    }
  }
}

extension RequestMode on EndPoint {
  RequestType get requestType {
    RequestType requestType = RequestType.get;

    switch (this) {
      // case EndPoint.getHomeFeed:
      //   requestType = RequestType.post;
      //   break;
      default:
        break;
    }

    return requestType;
  }
}

extension Token on EndPoint {
  bool get shouldAddToken {
    var shouldAdd = true;

    switch (this) {
      case EndPoint.getHomeFeed:
        shouldAdd = false;
        break;
      default:
        break;
    }

    return shouldAdd;
  }
}
