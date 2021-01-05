import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_model_event.dart';
import 'package:next_synth/piano_roll/piano_roll_model_listener.dart';

import './piano_roll_style.dart';
import '../event/notification_event.dart';
import '../event/notification_listener.dart' as P;
import 'key.dart' as P;
import 'key_color.dart';
import 'key_table.dart';
import 'note.dart';
import 'piano_roll.dart';

class PianoRollRenderBox extends RenderBox
    implements PianoRollModelListener, P.NotificationListener<PianoRollStyle> {
  PianoRoll _state;
  List<Rect> _highlightRects;

  PianoRollRenderBox(this._state) {
    this._highlightRects = List<Rect>();
    _state.style.addNotificationListener(this);
    _state.model.addPianoRollModelListener(this);
  }

  PianoRoll get state => _state;
  set state(PianoRoll state) {
    _state.style.removeNotificationListener(this);
    _state.model.removePianoRollModelListener(this);
    _state = state;
    _state.style.addNotificationListener(this);
    _state.model.addPianoRollModelListener(this);
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  Rect computeClipRect() {
    double sx = -_state.style.scrollOffset.dx;
    double sy = -_state.style.scrollOffset.dy;
    double w = size.width;
    double h = size.height;
    return Rect.fromLTWH(sx, sy, w, h);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;

    double sx = _state.style.scrollOffset.dx;
    double sy = _state.style.scrollOffset.dy;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
        offset.dx, offset.dy, size.width + offset.dx, size.height));
    canvas.translate(sx + offset.dx, sy + offset.dy + 50);
    _paintImpl(context, offset);
    canvas.restore();
  }

  void _paintImpl(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    var style = _state.style;
    var model = _state.model;
    int bw = style.beatWidth;
    int bh = style.beatHeight;
    var clipRect = computeClipRect();
    int startKey = clipRect.top.toInt();
    int endKey = (clipRect.top + clipRect.height).toInt();
    int y = 0;
    int index = 0;
    _drawBackground(canvas, size);
    for (int i = model.keyCount - 1; i >= 0; i--) {
      int nextY = y + bh;
      if (y < startKey || y >= endKey) {
        y = nextY;
        index++;
        continue;
      }
      // drawNotes
      _drawNotes(canvas, size, model.getKeyAt(index), y, nextY, false, null);
      y = nextY;
      index++;
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    var style = _state.style;
    var model = _state.model;
    int bw = style.beatWidth;
    int bh = style.beatHeight;
    int cw = _state.computeMaxWidth();
    var clipRect = computeClipRect();
    int startKey = clipRect.top.toInt();
    int endKey = (clipRect.top + clipRect.height).toInt();
    int index = 0;
    int y = 0;
    _highlightRects.clear();
    for (int i = model.keyCount - 1; i >= 0; i--) {
      int nextY = y + bh;
      if (y < startKey || y >= endKey) {
        y = nextY;
        index++;
        continue;
      }
      int indexInBwTable = i % KeyTable.basic.length;
      var keyColor = KeyTable.basic.getColorAt(indexInBwTable);
      var keyPaint = _getPaintForKey(keyColor);
      // TODO: ドラッグ中のハイライト
      canvas.drawRect(
          Rect.fromLTRB(0, y.toDouble(), cw.toDouble(), nextY.toDouble()),
          keyPaint);
      _drawKey(canvas, size, model.getKeyAt(index), y, nextY);
      canvas.drawLine(
          Offset(0, y.toDouble()),
          Offset(_state.computeKeyWidth().toDouble(), y.toDouble()),
          _getPaintForKey(KeyColor.black));
      y = nextY;
      index++;
    }
    //*
    canvas.drawLine(
        Offset(0, _state.computeMaxHeight().toDouble()),
        Offset(_state.computeMaxWidth().toDouble(),
            _state.computeMaxHeight().toDouble()),
        _getPaintForKey(KeyColor.black));
    canvas.drawLine(
        Offset(_state.computeMaxWidth().toDouble(), 0),
        Offset(_state.computeMaxWidth().toDouble(),
            _state.computeMaxHeight().toDouble()),
        _getPaintForKey(KeyColor.black));
    //*/
  }

  void _drawKey(Canvas canvas, Size size, P.Key key, int topY, int bottomY) {
    int bw = _state.style.beatWidth;
    int bh = _state.style.beatHeight;
    int mx = 0;
    for (int i = 0; i < key.measureCount; i++) {
      var m = key.getMeasureAt(i);
      int bx = (bw * m.beatCount) * i;
      for (int j = 0; j < m.beatCount; j++) {
        int nextBx = bx + bw;
        for (int k = 0; k < _state.style.beatSplitCount; k++) {
          double lineX = bx + (k * (bw / _state.style.beatSplitCount));
          canvas.drawLine(
              Offset(lineX, topY.toDouble()),
              Offset(lineX, bottomY.toDouble()),
              _state.style.verticalLinePaint);
        }
        canvas.drawLine(
            Offset(bx.toDouble(), topY.toDouble()),
            Offset(bx.toDouble(), bottomY.toDouble()),
            _state.style.verticalLinePaint);
        bx = nextBx;
      }
      int nextMx = mx + m.beatCount * bw;
      canvas.drawLine(
          Offset(mx.toDouble(), topY.toDouble()),
          Offset(mx.toDouble(), bottomY.toDouble()),
          _state.style.verticalHighlightLinePaint);
      mx = nextMx;
    }
  }

  void _drawNotes(Canvas canvas, Size size, P.Key key, int topY, int bottomY,
      bool onionSkin, Color onionSkinColor) {
    int bw = _state.style.beatWidth;
    int bh = _state.style.beatHeight;
    for (int i = 0; i < key.measureCount; i++) {
      var m = key.getMeasureAt(i);
      int bx = (bw * m.beatCount) * i;
      for (int j = 0; j < m.beatCount; j++) {
        var beat = m.getBeatAt(j);
        int nextBx = bx + bw;
        for (int L = 0; L < beat.noteCount; L++) {
          var note = beat.getNoteAt(L);
          _drawNote(
              canvas,
              size,
              note,
              _state.computeNoteRect(note, note.offset, note.length),
              onionSkin,
              onionSkinColor);
        }
        bx = nextBx;
      }
    }
  }

  void _drawNote(Canvas canvas, Size size, Note note, Rect rect, bool onionSkin,
      Color onionSkinColor) {
    if (onionSkin) {
      // TODO: オニオンスキン
      return;
    }
    var paint = note.selected
        ? _state.style.selectedNotePaint
        : _state.style.unselectedNotePaint;
    canvas.drawRect(rect, paint);
    if (!onionSkin) {
      canvas.drawRect(rect, _state.style.noteFramePaint1);
      var innerRect = Rect.fromLTRB(rect.left + 1, rect.top + 1,
          rect.left + rect.width - 1, rect.top + rect.height - 1);
      canvas.drawRect(innerRect, _state.style.noteFramePaint2);
    }
  }

  Paint _getPaintForKey(KeyColor color) {
    if (color == KeyColor.black) {
      return _state.style.blackKeyPaint;
    }
    return _state.style.whiteKeyPaint;
  }

  @override
  void pianoRollModelUpdate(PianoRollModelEvent e) {
    this.markNeedsPaint();
  }

  @override
  void notify(NotificationEvent<PianoRollStyle> e) {
    this.markNeedsPaint();
  }
}
