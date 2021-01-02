import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
part 'piano_roll_data.g.dart';

@JsonSerializable(anyMap: true)
class PianoRollData {
  int keyCount;
  int measureCount;
  int beatCount;

  PianoRollData() {
    this.keyCount = 0;
    this.measureCount = 0;
    this.beatCount = 0;
  }

  static PianoRollData fromModel(PianoRollModel model) {
    var data = PianoRollData()
      ..keyCount = model.keyCount
      ..measureCount = model.getKeyAt(0).measureCount
      ..beatCount = model.getKeyAt(0).getMeasureAt(0).beatCount;
    return data;
  }

  PianoRollModel toModel() {
    var model = DefaultPianoRollModel(keyCount, measureCount, beatCount);
    return model;
  }

  factory PianoRollData.fromJson(Map json) => _$PianoRollDataFromJson(json);
  Map<String, dynamic> toJson() => _$PianoRollDataToJson(this);
}
