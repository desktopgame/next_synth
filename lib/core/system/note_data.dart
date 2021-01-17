import 'package:json_annotation/json_annotation.dart';

part 'note_data.g.dart';

@JsonSerializable(anyMap: true)
class NoteData {
  int keyIndex;
  int measureIndex;
  int beatIndex;
  bool selected;
  int offset;
  double length;

  NoteData() {
    this.keyIndex = 0;
    this.measureIndex = 0;
    this.beatIndex = 0;
    this.selected = false;
    this.offset = 0;
    this.length = 0;
  }

  factory NoteData.fromJson(Map json) => _$NoteDataFromJson(json);
  Map<String, dynamic> toJson() => _$NoteDataToJson(this);
}
