import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/note_drag_manager.dart';
import 'package:next_synth/piano_roll/note_resize_manager.dart';
import 'package:next_synth/piano_roll/piano_roll_selection_mode.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';
import 'package:next_synth/piano_roll/rect_select_manager.dart';
import 'package:optional/optional.dart';

import './key.dart' as P;
import './measure.dart';
import './note.dart';
import './piano_roll_model.dart';
import './piano_roll_range.dart';
import './piano_roll_style.dart';
import './piano_roll_ui.dart';
import './piano_roll_utilities.dart';

class PianoRollContext implements PianoRollUI {
  final PianoRollModel model;
  final PianoRollStyle style;
  final PianoRollRange range;
  RectSelectManager _rectSelectManager;
  NoteDragManager _noteDragManager;
  NoteResizeManager _noteResizeManager;
  PianoRollSelectionMode selectionMode;

  PianoRollContext(this.model, this.style)
      : range = PianoRollRange(),
        selectionMode = PianoRollSelectionMode.tap {}

  RectSelectManager get rectSelectManager {
    if (_rectSelectManager == null) {
      _rectSelectManager = RectSelectManager();
    }
    return _rectSelectManager;
  }

  NoteDragManager get noteDragManager {
    if (_noteDragManager == null) {
      _noteDragManager = NoteDragManager(this);
    }
    return _noteDragManager;
  }

  NoteResizeManager get noteResizeManager {
    if (_noteResizeManager == null) {
      _noteResizeManager = NoteResizeManager();
    }
    return _noteResizeManager;
  }

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

  Rect horizontalScrollBarRect(
      Offset offset, double top, double bottom, double width) {
    var mw = computeMaxWidth();
    var parW = width / mw;
    offset = offset.translate(-(range.scrollOffset.dx * parW), 0);
    //var offset = range.scrollOffset;
    return Rect.fromLTRB(offset.dx, top, offset.dx + (parW * width), bottom);
  }

  Rect verticalScrollBarRect(
      Offset offset, double left, double right, double height) {
    var mh = computeMaxHeight();
    var parH = height / mh;
    offset = offset.translate(0, -((range.scrollOffset.dy * parH)));
    return Rect.fromLTRB(left, offset.dy, right, offset.dy + (parH * height));
  }
}
