// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MyGenerator
// **************************************************************************

import 'dart:convert';
import './app_data.dart';
import 'package:optional/optional.dart';
import 'package:save_data_lib/save_data_lib.dart';

class AppDataProvider implements Provider {
  Optional<Object> _cache = Optional.empty();

  @override
  Optional<Object> get cache => _cache;

  @override
  void fromJson(String str) {
    this._cache = Optional.of(AppData.fromJson(json.decode(str)));
  }

  @override
  void clear() {
    this._cache = Optional.of(AppData());
  }

  @override
  String toJson() {
    return _cache.isPresent
        ? json.encode((_cache.value as AppData).toJson())
        : "{}";
  }

  static void setup() {
    SaveData.instance.register("AppData", AppDataProvider());
  }

  static Optional<AppData> provide() {
    return SaveData.instance.cache("AppData");
  }

  static void discard() {
    SaveData.instance.discard("AppData");
  }

  static Future<AppData> load() async {
    return await SaveData.instance.load("AppData");
  }

  static Future<void> save() async {
    return await SaveData.instance.save("AppData");
  }
}
