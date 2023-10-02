import 'dart:core';

import 'package:get_storage/get_storage.dart';

class PreferenceUtil {
  static final _instance = PreferenceUtil._internal();
  static final _preference = GetStorage();

  static PreferenceUtil get on => _instance;

  PreferenceUtil._internal();

  T? read<T>(String key, {T? defaultValue}) {
    return _preference.read(key) ?? defaultValue;
  }

  Future<void> write<T>(String key, T value) {
    return _preference.write(key, value);
  }

  bool contains(String key) {
    return _preference.hasData(key);
  }

  Future<void> delete(String key) async {
    return _preference.remove(key);
  }

  Future<void> clear() async {
    await _preference.erase();
  }
}
