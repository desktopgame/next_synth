import 'package:json_annotation/json_annotation.dart';
import 'package:property_ui_annotation/property_ui_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';

class TempProjectData {
  @Property(displayName: "オクターブ数")
  int keyCount;
  @Property(displayName: "小節の数")
  int measureCount;
  @Property(displayName: "小節内の拍の数")
  int beatCount;

  TempProjectData() {
    this.keyCount = 11;
    this.measureCount = 4;
    this.beatCount = 4;
  }
}
