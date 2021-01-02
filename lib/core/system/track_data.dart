import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
import './piano_roll_data.dart';
part 'track_data.g.dart';

@JsonSerializable(anyMap: true)
class TrackData {
  String name;
  bool isMute;
  PianoRollData pianoRollData;

  TrackData() {
    this.name = "";
    this.isMute = false;
    this.pianoRollData = null;
  }
  factory TrackData.fromJson(Map json) => _$TrackDataFromJson(json);
  Map<String, dynamic> toJson() => _$TrackDataToJson(this);
}
