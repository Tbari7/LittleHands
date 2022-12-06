import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._private();

  static late final SharedPreferences _sharedPref;

  static Future<void> initSharedPref() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  static const String _isRememberMe = "is_remember_me";
  static const String _userDetails = "user_details";
  static const String _childAge = "child_age";
  static const String _childName = "child_name";
  static const String _childGender = "child_gender";

  static set setIsRememberMe(bool isRememberMe) {
    _sharedPref.setBool(_isRememberMe, isRememberMe);
  }

  static set setUserDetails(String email) {
    _sharedPref.setString(_userDetails, email);
  }

  static set setChildAge(int age) {
    _sharedPref.setInt(_childAge, age);
  }

  static set setChildName(String name) {
    _sharedPref.setString(_childName, name);
  }

  static set setChildGender(String gender) {
    _sharedPref.setString(_childGender, gender);
  }

  static bool get getIsRememberMe {
    return _sharedPref.getBool(_isRememberMe) ?? false;
  }

  static String get getUserDetails {
    return _sharedPref.getString(_userDetails) ?? "";
  }

  static int? get getChildAge {
    return _sharedPref.getInt(_childAge);
  }

  static String get getChildName {
    return _sharedPref.getString(_childName) ?? "";
  }

  static String get getChildGender {
    return _sharedPref.getString(_childGender) ?? "";
  }

  static void signOut() => _sharedPref.clear();
}
