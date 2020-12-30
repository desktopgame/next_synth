// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MyGenerator
// **************************************************************************

import 'dart:convert';
import './project_list.dart';
import 'package:optional/optional.dart';
import 'package:save_data_lib/save_data_lib.dart';

class ProjectListProvider implements Provider {
  Optional<Object> _cache = Optional.empty();

  @override
  Optional<Object> get cache => _cache;

  @override
  void fromJson(String str) {
    this._cache = Optional.of(ProjectList.fromJson(json.decode(str)));
  }

  @override
  void clear() {
    this._cache = Optional.of(ProjectList());
  }

  @override
  String toJson() {
    return _cache.isPresent
        ? json.encode((_cache.value as ProjectList).toJson())
        : "{}";
  }

  static void setup() {
    SaveData.instance.register("ProjectList", ProjectListProvider());
  }

  static Optional<ProjectList> provide() {
    return SaveData.instance.cache("ProjectList");
  }

  static void discard() {
    SaveData.instance.discard("ProjectList");
  }

  static Future<ProjectList> load() async {
    return await SaveData.instance.load("ProjectList");
  }

  static Future<void> save() async {
    return await SaveData.instance.save("ProjectList");
  }
}
