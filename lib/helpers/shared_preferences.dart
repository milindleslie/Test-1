import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // Singleton
  static final SharedPreferenceHelper shared = SharedPreferenceHelper._privateConstructor();

  SharedPreferenceHelper._privateConstructor();

  //Keys
  final String _authToken = "authToken";

//  Token
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authToken);
  }

  Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_authToken, value);
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_authToken);
  }
}
