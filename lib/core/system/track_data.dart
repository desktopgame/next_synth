import 'package:json_annotation/json_annotation.dart';

import './piano_roll_data.dart';

part 'track_data.g.dart';

@JsonSerializable(anyMap: true)
class TrackData {
  String name;
  bool isMute;
  int channel;
  PianoRollData pianoRollData;

  TrackData() {
    this.name = "";
    this.channel = 0;
    this.isMute = false;
    this.pianoRollData = null;
  }
  factory TrackData.fromJson(Map json) => _$TrackDataFromJson(json);
  Map<String, dynamic> toJson() => _$TrackDataToJson(this);
}
