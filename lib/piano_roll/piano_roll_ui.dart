import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import './key.dart' as P;
import './measure.dart';
import './note.dart';
import './piano_roll_style.dart';

abstract class PianoRollUI {
  PianoRollStyle get style;
  int computeMaxWidth();
  int computeMaxHeight();
  int computeWidth(int measureCount);
  int computeHeight(int keyCount);
  int computeMeasureWidth();
  int computeKeyWidth();
  Rect computeNoteRect(Note note, int offset, double length);
  Optional<P.Key> getKeyAt(double y);
  Optional<int> getMeasureIndexAt(double x);
  Optional<Measure> getMeasureAt(double x, double y);
  List<Note> getNotesAt(double x, double y);
  int computeRelativeBeatIndex(double x);
  double measureIndexToXOffset(int i);
  double relativeBeatIndexToXOffset(int i);
}
