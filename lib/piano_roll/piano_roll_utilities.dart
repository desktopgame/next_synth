import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'dart:math';

import './beat.dart';
import './key.dart' as P;
import './measure.dart';
import './note.dart';
import './piano_roll.dart';
import './piano_roll_model.dart';
import './piano_roll_style.dart';

class PianoRollUtilities {
  PianoRollUtilities._();

  static bool _nearEq(int a, int b, int limit) {
    return (a.abs() - b.abs()) < limit;
  }

  static Optional<Note> generateNoteAt(
      PianoRoll state, double x, double y, int offset, double length) {
    int section = state.style.beatWidth ~/ state.style.beatSplitCount;
    for (int i = 0; i < state.style.beatSplitCount; i++) {
      //if (_nearEq(section * i, offset, 5)) {
      //  offset = section * i;
      //  break;
      //}
    }
    final int offsetA = offset;
    return state.getMeasureAt(x, y).map((Measure e) {
      int i = state.computeRelativeBeatIndex(x);
      return e.getBeatAt(i).generateNote(offsetA, length);
    });
  }

  static Optional<Note> generateOrRemoveAt(
      PianoRoll state, double x, double y, double length) {
    var notes = state.getNotesAt(x, y);
    if (notes.isEmpty) {
      var optI = state.getMeasureIndexAt(x);
      int rbi = state.computeRelativeBeatIndex(x);
      double xOffset = state.measureIndexToXOffset(optI.value) +
          state.relativeBeatIndexToXOffset(rbi);
      if ((x - xOffset) < 5) {
        xOffset = x;
      }
      if (optI.isPresent) {
        return generateNoteAt(state, x, y, (x - xOffset).toInt(), length);
      }
      return generateNoteAt(state, x, y, 0, length);
    } else {
      for (Note n in notes) {
        n.removeFromBeat();
      }
    }
    return Optional.empty();
  }

  static int computeMaxWidth(PianoRollModel model, PianoRollStyle style) {
    if (model == null) {
      return 0;
    }
    return computeWidth(model, style, model.getKeyAt(0).measureCount);
  }

  static int computeMaxHeight(PianoRollModel model, PianoRollStyle style) {
    if (model == null) {
      return 0;
    }
    return computeHeight(style, model.keyCount);
  }

  static int computeWidth(
      PianoRollModel model, PianoRollStyle style, int measureCount) {
    if (model == null) {
      return 0;
    }
    int mc = measureCount;
    int bc = model.getKeyAt(0).getMeasureAt(0).beatCount;
    int w = (bc * style.beatWidth) * mc;
    return w;
  }

  static int computeHeight(PianoRollStyle style, int keyCount) {
    int h = keyCount * style.beatHeight;
    return h;
  }

  static int computeMeasureWidth(PianoRollModel model, PianoRollStyle style) {
    return model.getKeyAt(0).getMeasureAt(0).beatCount * style.beatWidth;
  }

  static int computeKeyWidth(PianoRollModel model, PianoRollStyle style) {
    return computeMeasureWidth(model, style) * model.getKeyAt(0).measureCount;
  }

  static Rect computeNoteRect(
      PianoRollStyle style, Note note, int offset, double length) {
    var beat = note.beat;
    var measure = beat.measure;
    var key = measure.key;
    var model = key.model;
    double xOffset = measureIndexToXOffset(model, style, measure.index);
    xOffset += style.beatWidth * beat.index;
    xOffset += offset;
    int yOffset = style.beatHeight * (model.keyCount - key.index + 1);
    yOffset = (style.beatHeight * model.keyCount) - yOffset;
    int width = (length * style.beatWidth.toDouble()).round();
    int height = style.beatHeight;
    return Rect.fromLTRB(xOffset.toDouble(), yOffset.toDouble(),
        (xOffset + width).toDouble(), (yOffset + height).toDouble());
  }

  static int computeRelativeBeatIndex(
      PianoRollModel model, PianoRollStyle style, double x) {
    return (x.toInt() %
            (style.beatWidth * model.getKeyAt(0).getMeasureAt(0).beatCount)) ~/
        style.beatWidth;
  }

  static double measureIndexToXOffset(
      PianoRollModel model, PianoRollStyle style, int i) {
    return ((model.getKeyAt(0).getMeasureAt(0).beatCount * style.beatWidth) * i)
        .toDouble();
  }

  static double relativeBeatIndexToXOffset(PianoRollStyle style, int i) {
    return (i * style.beatWidth).toDouble();
  }

  static List<Note> getAllNoteList(PianoRollModel model) {
    var ret = List<Note>();
    for (P.Key k in getKeyList(model)) {
      for (Measure m in getMeasureList(k)) {
        for (Beat b in getBeatList(m)) {
          ret.addAll(getNoteList(b));
        }
      }
    }
    return ret;
  }

  static List<Note> getNoteList(Beat beat) {
    var ret = List<Note>();
    for (int i = 0; i < beat.noteCount; i++) {
      ret.add(beat.getNoteAt(i));
    }
    return ret;
  }

  static List<Beat> getBeatList(Measure measure) {
    var ret = List<Beat>();
    for (int i = 0; i < measure.beatCount; i++) {
      ret.add(measure.getBeatAt(i));
    }
    return ret;
  }

  static List<Measure> getMeasureList(P.Key key) {
    var ret = List<Measure>();
    for (int i = 0; i < key.measureCount; i++) {
      ret.add(key.getMeasureAt(i));
    }
    return ret;
  }

  static List<P.Key> getKeyList(PianoRollModel model) {
    var ret = List<P.Key>();
    for (int i = 0; i < model.keyCount; i++) {
      ret.add(model.getKeyAt(i));
    }
    return ret;
  }

  static void clearAllNoteSelection(PianoRollModel model) {
    for (Note n in getAllNoteList(model)) {
      n.selected = false;
    }
  }

  static int scaledNoteLength(Note note, int beatWidth) {
    return (note.length * beatWidth.toDouble()).round();
  }

  static bool equals(PianoRollModel a, PianoRollModel b) {
    var al = PianoRollUtilities.getAllNoteList(a);
    var bl = PianoRollUtilities.getAllNoteList(b);
    if (al.length != bl.length) {
      return false;
    }
    if (a.keyCount != b.keyCount) {
      return false;
    }
    for (int i = 0; i < al.length; i++) {
      var ae = al[i];
      var be = bl[i];
      var maxLen = max(ae.length, be.length);
      var minLen = min(ae.length, be.length);
      if (ae.beat.index != be.beat.index ||
          ae.beat.measure.index != be.beat.measure.index ||
          ae.beat.measure.key.index != be.beat.measure.key.index ||
          ae.selected != be.selected ||
          maxLen - minLen >= 0.01) {
        return false;
      }
    }

    return true;
  }
}
