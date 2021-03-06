import 'package:json_annotation/json_annotation.dart';
import 'package:property_ui_annotation/property_ui_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';

part 'app_data.g.dart';

@JsonSerializable(anyMap: true)
@Content()
class AppData {
  @Property(displayName: "BPM")
  int bpm;
  @Property(displayName: "オクターブ数")
  int keyCount;
  @Property(displayName: "拍の横幅")
  int beatWidth;
  @Property(displayName: "拍の縦幅")
  int beatHeight;
  @Property(displayName: "小節の数")
  int measureCount;
  @Property(displayName: "小節内の拍の数")
  int beatCount;
  @Property(displayName: "拍の分割数")
  int beatSplitCount;
  @Property(displayName: "キーボードの横幅")
  int keyboardWidth;
  @Property(displayName: "ツールバーの高さ")
  int toolBarHeight;
  int launchCount;
  int lastOpenProjectIndex;

  @Property(displayName: "ダークテーマ")
  bool darkTheme;

  @Property(displayName: "デバッグ表示", debug: true)
  bool showDebugLabel;

  bool settingUpdated;

  AppData() {
    this.bpm = 120;
    this.keyCount = 11;
    this.beatWidth = 96;
    this.beatHeight = 16;
    this.measureCount = 4;
    this.beatCount = 4;
    this.beatSplitCount = 4;
    this.keyboardWidth = 48;
    this.toolBarHeight = 50;
    this.launchCount = 0;
    this.lastOpenProjectIndex = -1;
    this.showDebugLabel = true;
    this.settingUpdated = false;
    this.darkTheme = false;
  }

  factory AppData.fromJson(Map json) => _$AppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataToJson(this);
  bool isValid() {
    if (this.settingUpdated == null) return false;
    if (this.showDebugLabel == null) return false;
    if (this.beatCount == null) return false;
    if (this.beatHeight == null) return false;
    if (this.beatSplitCount == null) return false;
    if (this.beatWidth == null) return false;
    if (this.bpm == null) return false;
    if (this.keyCount == null) return false;
    if (this.keyboardWidth == null) return false;
    if (this.lastOpenProjectIndex == null) return false;
    if (this.launchCount == null) return false;
    if (this.measureCount == null) return false;
    if (this.toolBarHeight == null) return false;
    if (this.darkTheme == null) return false;
    return true;
  }
}
