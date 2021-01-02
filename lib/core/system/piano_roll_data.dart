import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
part 'piano_roll_data.g.dart';

@JsonSerializable(anyMap: true)
class PianoRollData {
  int measureCount;

  PianoRollData() {
    this.measureCount = 0;
  }
  factory PianoRollData.fromJson(Map json) => _$PianoRollDataFromJson(json);
  Map<String, dynamic> toJson() => _$PianoRollDataToJson(this);
}
