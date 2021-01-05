import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';

import './project.dart';

part 'project_list.g.dart';

@JsonSerializable(anyMap: true)
@Content()
class ProjectList {
  List<Project> data;

  ProjectList() {
    this.data = List<Project>();
  }
  factory ProjectList.fromJson(Map json) => _$ProjectListFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectListToJson(this);
}
