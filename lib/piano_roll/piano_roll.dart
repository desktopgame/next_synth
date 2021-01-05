import 'package:next_synth/piano_roll/piano_roll_model_event.dart';
import 'package:next_synth/piano_roll/piano_roll_model_listener.dart';
import 'package:flutter/material.dart';
import './piano_roll_render_box.dart';
import 'package:optional/optional.dart';
import './measure.dart';
import './piano_roll_editor.dart';
import './piano_roll_editor_state.dart';
import './piano_roll_utilities.dart';
import './default_piano_roll_model.dart';
import './piano_roll_model.dart';
import './piano_roll_style.dart';
import './key.dart' as P;
import './note.dart';
import './reference.dart';
import 'piano_roll_render_box.dart';

class PianoRoll extends SingleChildRenderObjectWidget {
  final Reference<PianoRollModel> _model;
  final PianoRollStyle _style;

  PianoRoll(this._model, this._style, {Key key}) : super(key: key) {}

  @override
  void updateRenderObject(
      BuildContext context, covariant PianoRollRenderBox renderObject) {
    renderObject.state = this;
  }

  PianoRollModel get model => _model.value;
  PianoRollStyle get style => _style;

  int computeMaxWidth() {
    if (model == null) {
      return 0;
    }
    return computeWidth(model.getKeyAt(0).measureCount);
  }

  int computeMaxHeight() {
    if (model == null) {
      return 0;
    }
    return computeHeight(model.keyCount);
  }

  int computeWidth(int measureCount) {
    if (model == null) {
      return 0;
    }
    int mc = measureCount;
    int bc = model.getKeyAt(0).getMeasureAt(0).beatCount;
    int w = (bc * style.beatWidth) * mc;
    return w;
  }

  int computeHeight(int keyCount) {
    if (model == null) {
      return 0;
    }
    int h = keyCount * style.beatHeight;
    return h;
  }

  int computeMeasureWidth() {
    return model.getKeyAt(0).getMeasureAt(0).beatCount * style.beatWidth;
  }

  int computeKeyWidth() {
    return computeMeasureWidth() * model.getKeyAt(0).measureCount;
  }

  Rect computeNoteRect(Note note, int offset, double length) {
    var beat = note.beat;
    var measure = beat.measure;
    var key = measure.key;
    double xOffset = measureIndexToXOffset(measure.index);
    xOffset += style.beatWidth * beat.index;
    xOffset += offset;
    int yOffset = style.beatHeight * (model.keyCount - key.index + 1);
    yOffset = (style.beatHeight * model.keyCount) - yOffset;
    int width = (length * style.beatWidth.toDouble()).round();
    int height = style.beatHeight;
    return Rect.fromLTRB(xOffset.toDouble(), yOffset.toDouble(),
        (xOffset + width).toDouble(), (yOffset + height).toDouble());
  }

  Optional<P.Key> getKeyAt(double y) {
    int i = y ~/ style.beatHeight;
    if (i < 0 || i >= model.keyCount) {
      return Optional.empty();
    }
    return Optional.of(model.getKeyAt(i));
  }

  Optional<int> getMeasureIndexAt(double x) {
    int i =
        x ~/ (style.beatWidth * model.getKeyAt(0).getMeasureAt(0).beatCount);
    if (i < 0 || i >= model.getKeyAt(0).measureCount) {
      return Optional.empty();
    }
    return Optional.of(i);
  }

  Optional<Measure> getMeasureAt(double x, double y) {
    var optI = getMeasureIndexAt(x);
    if (optI.isPresent) {
      return getKeyAt(y).map((P.Key e) => e.getMeasureAt(optI.value));
    }
    return Optional.empty();
  }

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

  int computeRelativeBeatIndex(double x) {
    return (x.toInt() %
            (style.beatWidth * model.getKeyAt(0).getMeasureAt(0).beatCount)) ~/
        style.beatWidth;
  }

  double measureIndexToXOffset(int i) {
    return ((model.getKeyAt(0).getMeasureAt(0).beatCount * style.beatWidth) * i)
        .toDouble();
  }

  double relativeBeatIndexToXOffset(int i) {
    return (i * style.beatWidth).toDouble();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PianoRollRenderBox(this);
  }
}
