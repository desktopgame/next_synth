import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
part 'project.g.dart';

@JsonSerializable(anyMap: true)
class Project {
  String name;
  Project() {
    this.name = "";
  }
  factory Project.fromJson(Map json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
