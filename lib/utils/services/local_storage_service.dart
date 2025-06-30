// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project/models/user_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

late WidgetRef globalRef;

void setRef(WidgetRef ref) {
  globalRef = ref;
}

class LocalStorageService {
  LocalStorageService() {
    initialize();
  }
  final String _userLoginKey = "userLogin";
  final String _auth_token = "auth_token";
  final String _profileImageKey = "profileImage";
  static const String _keyFcmToken = "fcm_token";
  String? fcmToken;
  String? _userToken;
  String? get mobileToken => fcmToken;

  String? get userToken => _userToken;

  set userToken(String? value) {
    _userToken = value;
  }

  /// บันทึก FCM token ลง SharedPreferences
  Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFcmToken, token);
    fcmToken = token;
  }

  /// อ่าน token ที่เก็บไว้
  Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFcmToken);
  }

  Future<String?> read(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> write(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> delete(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  //delete user token
  Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = null;
    await prefs.remove(_auth_token);
  }

  Future<void> deleteAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = null;
    await prefs.clear();
  }

  Future<void> saveToken(String token) async {
    userToken = token;
    await write(_auth_token, token);
  }

  Future<String?> getToken() async {
    userToken = await read(_auth_token);
    return userToken;
  }

  late String _applicationVersion;
  String get applicationVersion => _applicationVersion;

  Future<void> initialize() async {
    await getToken();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _applicationVersion = packageInfo.version;

    if (kIsWeb) {
      _applicationPlatform = "web";
    } else if (Platform.isAndroid) {
      _applicationPlatform = "android";
      return;
    } else if (Platform.isIOS) {
      _applicationPlatform = "ios";
      return;
    } else {
      _applicationPlatform = null;
      return;
    }
  }

  late String? _applicationPlatform;
  String? get applicationPlatform => _applicationPlatform;

  UserLoginModel _userLoginData = const UserLoginModel();
  UserLoginModel get userLoginData => _userLoginData;

  Future<void> saveUserLogin(UserLoginModel value) async {
    _userLoginData = value;
    await write(_userLoginKey, jsonEncode(value.toJson()));
    await getUserLogin();
  }

  Future<UserLoginModel> getUserLogin() async {
    var dataUser = await read(_userLoginKey);
    try {
      _userLoginData = UserLoginModel.fromJson(jsonDecode(dataUser!));
      return userLoginData;
    } catch (e) {
      return const UserLoginModel();
    }
  }

  String? _profileImage;
  String? get profileImage => _profileImage;

  Future<void> saveProfileImage(String value) async {
    _profileImage = value;
    await write(_profileImageKey, jsonEncode(value));
  }

  Future<String> getsaveProfileImage() async {
    var dataProfileImage = await read(_profileImageKey);
    try {
      _profileImage = dataProfileImage;
      return profileImage!;
    } catch (e) {
      return "";
    }
  }
}

/// ##########################
final localStorageServiceProvider = Provider<LocalStorageService>((ref) => LocalStorageService());
