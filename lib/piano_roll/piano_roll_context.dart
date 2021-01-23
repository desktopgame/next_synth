import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import './key.dart' as P;
import './measure.dart';
import './note.dart';
import './piano_roll_model.dart';
import './piano_roll_style.dart';
import './piano_roll_ui.dart';
import './piano_roll_utilities.dart';

class PianoRollContext implements PianoRollUI {
  final PianoRollModel model;
  final PianoRollStyle style;

  PianoRollContext(this.model, this.style);

  @override
  int computeMaxWidth() => PianoRollUtilities.computeMaxWidth(model, style);

  @override
  int computeMaxHeight() => PianoRollUtilities.computeMaxHeight(model, style);

  @override
  int computeWidth(int measureCount) =>
      PianoRollUtilities.computeWidth(model, style, measureCount);

  @override
  int computeHeight(int keyCount) =>
      PianoRollUtilities.computeHeight(style, keyCount);

  @override
  int computeMeasureWidth() =>
      PianoRollUtilities.computeMeasureWidth(model, style);

  @override
  int computeKeyWidth() => PianoRollUtilities.computeKeyWidth(model, style);

  @override
  Rect computeNoteRect(Note note, int offset, double length) =>
      PianoRollUtilities.computeNoteRect(style, note, offset, length);

  @override
  Optional<P.Key> getKeyAt(double y) {
    int i = y ~/ style.beatHeight;
    if (i < 0 || i >= model.keyCount) {
      return Optional.empty();
    }
    return Optional.of(model.getKeyAt(i));
  }

  @override
  Optional<int> getMeasureIndexAt(double x) {
    int i =
        x ~/ (style.beatWidth * model.getKeyAt(0).getMeasureAt(0).beatCount);
    if (i < 0 || i >= model.getKeyAt(0).measureCount) {
      return Optional.empty();
    }
    return Optional.of(i);
  }

  @override
  Optional<Measure> getMeasureAt(double x, double y) {
    var optI = getMeasureIndexAt(x);
    if (optI.isPresent) {
      return getKeyAt(y).map((P.Key e) => e.getMeasureAt(optI.value));
    }
    return Optional.empty();
  }

  @override
  List<Note> getNotesAt(double x, double y) {
    var notes = List<Note>();
    getKeyAt(y).ifPresent((P.Key e) {
      for (int i = 0; i < e.measureCount; i++) {
        var m = e.getMeasureAt(i);
        int measureOffset = (style.beatWidth * m.beatCount) * i;
        for (int j = 0; j < m.beatCount; j++) {
          var b = m.getBeatAt(j);
          int beatOffset = measureOffset + (style.beatWidth * j);
          for (int k = 0; k < b.noteCount; k++) {
            var n = b.getNoteAt(k);
            int sx = beatOffset + n.offset;
            int ex =
                sx + PianoRollUtilities.scaledNoteLength(n, style.beatWidth);
            if (x >= sx && x < ex) {
              notes.add(n);
            }
          }
        }
      }
    });
    return notes;
  }

  @override
  int computeRelativeBeatIndex(double x) =>
      PianoRollUtilities.computeRelativeBeatIndex(model, style, x);

  @override
  double measureIndexToXOffset(int i) =>
      PianoRollUtilities.measureIndexToXOffset(model, style, i);

  @override
  double relativeBeatIndexToXOffset(int i) =>
      PianoRollUtilities.relativeBeatIndexToXOffset(style, i);
}
