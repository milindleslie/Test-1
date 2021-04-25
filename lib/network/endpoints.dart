import 'package:test_app/resources/constants.dart';

import 'network_adapter.dart';

enum EndPoint {
  allEvents,
  eventDetails,
  checkout,
  purchase,
}

extension URLExtenssion on EndPoint {
  static final String _baseUrl = AppConstants.baseURL;

  String get url {
    switch (this) {
      case EndPoint.allEvents:
        return _baseUrl + '/allEvents';
      case EndPoint.eventDetails:
        return _baseUrl + '/eventDetails';
      case EndPoint.checkout:
        return _baseUrl + '/checkout';
      case EndPoint.purchase:
        return _baseUrl + '/purchase';
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
      case EndPoint.purchase:
        requestType = RequestType.post;
        break;
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
      // case EndPoint.purchase:
      //   shouldAdd = false;
      //   break;
      default:
        break;
    }

    return shouldAdd;
  }
}
