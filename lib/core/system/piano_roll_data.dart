import 'package:json_annotation/json_annotation.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';

import './note_data.dart';

part 'piano_roll_data.g.dart';

@JsonSerializable(anyMap: true)
class PianoRollData {
  int keyCount;
  int measureCount;
  int beatCount;
  List<NoteData> notes;

  PianoRollData() {
    this.keyCount = 0;
    this.measureCount = 0;
    this.beatCount = 0;
    this.notes = [];
  }

  static PianoRollData fromModel(PianoRollModel model) {
    var data = PianoRollData()
      ..keyCount = model.keyCount
      ..measureCount = model.getKeyAt(0).measureCount
      ..beatCount = model.getKeyAt(0).getMeasureAt(0).beatCount
      ..notes = PianoRollUtilities.getAllNoteList(model)
          .map((e) => NoteData()
            ..keyIndex = e.beat.measure.key.index
            ..measureIndex = e.beat.measure.index
            ..beatIndex = e.beat.index
            ..selected = e.selected
            ..offset = e.offset
            ..length = e.length)
          .toList();
    return data;
  }

  PianoRollModel toModel() {
    var model = DefaultPianoRollModel(keyCount, measureCount, beatCount);
    for (var note in notes) {
      var k = model.getKeyAt(note.keyIndex);
      var m = k.getMeasureAt(note.measureIndex);
      var b = m.getBeatAt(note.beatIndex);
      if (note.selected == null) {
        note.selected = false;
      }
      b.generateNote(note.offset, note.length)..selected = note.selected;
    }
    return model;
  }

  factory PianoRollData.fromJson(Map json) => _$PianoRollDataFromJson(json);
  Map<String, dynamic> toJson() => _$PianoRollDataToJson(this);
}
