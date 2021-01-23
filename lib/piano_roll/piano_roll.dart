import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_context.dart';
import 'package:optional/optional.dart';

import './key.dart' as P;
import './measure.dart';
import './note.dart';
import './piano_roll_model.dart';
import './piano_roll_render_box.dart';
import './piano_roll_style.dart';
import './piano_roll_ui.dart';
import 'piano_roll_render_box.dart';

class PianoRoll extends SingleChildRenderObjectWidget implements PianoRollUI {
  final PianoRollContext _context;

  PianoRoll(this._context, {Key key}) : super(key: key) {}

  PianoRollContext get context => _context;

  @override
  void updateRenderObject(
      BuildContext context, covariant PianoRollRenderBox renderObject) {
    renderObject.pianoRoll = this;
  }

  PianoRollModel get model => _context.model;
  PianoRollStyle get style => _context.style;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PianoRollRenderBox(this);
  }

  @override
  int computeMaxWidth() => _context.computeMaxWidth();
  @override
  int computeMaxHeight() => _context.computeMaxHeight();
  @override
  int computeWidth(int measureCount) => _context.computeWidth(measureCount);
  @override
  int computeHeight(int keyCount) => _context.computeHeight(keyCount);
  @override
  int computeMeasureWidth() => _context.computeMeasureWidth();
  @override
  int computeKeyWidth() => _context.computeKeyWidth();
  @override
  Rect computeNoteRect(Note note, int offset, double length) =>
      _context.computeNoteRect(note, offset, length);
  @override
  Optional<P.Key> getKeyAt(double y) => _context.getKeyAt(y);
  @override
  Optional<int> getMeasureIndexAt(double x) => _context.getMeasureIndexAt(x);
  @override
  Optional<Measure> getMeasureAt(double x, double y) =>
      _context.getMeasureAt(x, y);
  @override
  List<Note> getNotesAt(double x, double y) => _context.getNotesAt(x, y);
  @override
  int computeRelativeBeatIndex(double x) =>
      _context.computeRelativeBeatIndex(x);
  @override
  double measureIndexToXOffset(int i) => _context.measureIndexToXOffset(i);
  @override
  double relativeBeatIndexToXOffset(int i) =>
      _context.relativeBeatIndexToXOffset(i);
}
