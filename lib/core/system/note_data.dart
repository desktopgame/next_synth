import 'package:json_annotation/json_annotation.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
part 'note_data.g.dart';

@JsonSerializable(anyMap: true)
class NoteData {
  int keyIndex;
  int measureIndex;
  int beatIndex;
  int offset;
  double length;

  NoteData() {
    this.keyIndex = 0;
    this.measureIndex = 0;
    this.beatIndex = 0;
    this.offset = 0;
    this.length = 0;
  }

  factory NoteData.fromJson(Map json) => _$NoteDataFromJson(json);
  Map<String, dynamic> toJson() => _$NoteDataToJson(this);
}
