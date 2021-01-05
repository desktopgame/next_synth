import 'package:json_annotation/json_annotation.dart';

import './track_data.dart';

part 'project.g.dart';

@JsonSerializable(anyMap: true)
class Project {
  String name;
  List<TrackData> tracks;
  Project() {
    this.name = "";
    this.tracks = [];
  }
  factory Project.fromJson(Map json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
