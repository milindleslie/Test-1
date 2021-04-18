class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    // return "$_prefix$_message";
    return "$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message]) : super(message, "");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request. ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised. ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input. ");
}

class NotFoundException extends AppException {
  NotFoundException([String message]) : super(message, "Not Found. ");
}

class InternalServerException extends AppException {
  InternalServerException([String message]) : super(message, "Internal Server Error. ");
}
