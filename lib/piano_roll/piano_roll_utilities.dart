import './piano_roll.dart';
import './piano_roll_model.dart';
import './key.dart' as P;
import './beat.dart';
import './note.dart';
import './measure.dart';
import 'package:optional/optional.dart';

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
}
