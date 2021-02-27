import 'package:json_annotation/json_annotation.dart';

import './app_data.save_data.dart';
import './track_data.dart';

part 'project.g.dart';

@JsonSerializable(anyMap: true)
class Project {
  String name;
  List<TrackData> tracks;
  int keyCount;
  int measureCount;
  int beatCount;
  Project() {
    this.name = "";
    this.tracks = [];
    this.keyCount = AppDataProvider.provide().value.keyCount;
    this.measureCount = AppDataProvider.provide().value.measureCount;
    this.beatCount = AppDataProvider.provide().value.beatCount;
  }
  factory Project.fromJson(Map json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
