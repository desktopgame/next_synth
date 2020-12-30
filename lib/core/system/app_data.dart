import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
part 'app_data.g.dart';

@JsonSerializable(anyMap: true)
@Content()
class AppData {
  int octaveCount;
  int beatWidth;
  int beatHeight;
  int measureCount;
  int beatCount;
  int beatSplitCount;
  int keyboardWidth;
  int toolBarHeight;
  int launchCount;

  AppData() {
    this.octaveCount = 11;
    this.beatWidth = 96;
    this.beatHeight = 16;
    this.measureCount = 4;
    this.beatCount = 4;
    this.beatSplitCount = 4;
    this.keyboardWidth = 48;
    this.toolBarHeight = 50;
    this.launchCount = 0;
  }

  factory AppData.fromJson(Map json) => _$AppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}
