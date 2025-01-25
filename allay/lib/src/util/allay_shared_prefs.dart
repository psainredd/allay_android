import 'dart:convert';

import 'package:allay/src/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllaySharedPrefs {
  final SharedPreferences _preferences;
  final String _loggedInUserNameLabel = "loggedInUserName";

  AllaySharedPrefs._(this._preferences);
  
  static AllaySharedPrefs? _instance;
  
  static Future<AllaySharedPrefs> getInstance() async {
    _instance ??=AllaySharedPrefs._(await SharedPreferences.getInstance());
    return _instance!;
  }

  String? getLoggedInUserName() {
    return _preferences.getString(_loggedInUserNameLabel);
  }

  Future<bool> setLoggedInUser(String userName) async {
    return _preferences.setString(_loggedInUserNameLabel, userName);
  }
}

Future<User?> getSavedUser() async {
  AllaySharedPrefs sharedPrefs = await AllaySharedPrefs.getInstance();
  String loggedInUserString = sharedPrefs.getLoggedInUserName()??"";
  if (loggedInUserString.isEmpty) {
    return null;
  }
  Map<String, dynamic> loggedInUserJson = jsonDecode(loggedInUserString);
  return User.fromJson(loggedInUserJson);
}

Future<User?> saveUser(User user) async {
  AllaySharedPrefs sharedPrefs = await AllaySharedPrefs.getInstance();
  await sharedPrefs.setLoggedInUser(jsonEncode(user));
  return getSavedUser();
}

final savedUserInfoProvider = StateNotifierProvider<SavedUserInfoNotifier, AsyncValue<User?>>((ref) {
  return SavedUserInfoNotifier();
});

class SavedUserInfoNotifier extends StateNotifier<AsyncValue<User?>> {
  SavedUserInfoNotifier() : super(const AsyncValue.loading()){
    _fetch();
  }

  void _fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => getSavedUser());
  }

  void update(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => saveUser(user));
  }
}