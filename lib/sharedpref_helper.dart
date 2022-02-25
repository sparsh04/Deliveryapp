import 'package:shared_preferences/shared_preferences.dart';
import "dart:core";

class SharedPreferncehelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userlatitude = '20.37373';
  static String userlongitude = '30.787281';
  static String displayNameKey = "USERDISPLAYNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";
  //for text field login screen
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";

  Future<bool> saveUserName(String? getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName!);
  }

  Future<bool> saveUserId(String? getuserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getuserId!);
  }

  Future<bool> saveDisplayName(String? getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName!);
  }

  Future<bool> saveProfileName(String? getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile!);
  }

  Future<bool> saveUserEmail(String? getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail!);
  }

  Future<bool> saveUserlatitude(double latitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(userlatitude, latitude);
  }

  Future<bool> saveUserlongitude(double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(userlongitude, longitude);
  }

//get data

  Future<double?>? getlatitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(userlatitude);
  }

  Future<double?>? getlongitude() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(userlongitude);
  }

  Future<String?>? getUSerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?>? getUSerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?>? getuseremail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?>? getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?>? getProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }

  //for the signin text field only
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }
}
