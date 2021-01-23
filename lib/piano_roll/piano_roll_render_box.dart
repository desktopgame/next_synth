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
  PianoRoll _pianoRoll;
  List<Rect> _highlightRects;
  List<Rect> _ghostRects;

  PianoRollRenderBox(this._pianoRoll) {
    this._highlightRects = List<Rect>();
    this._ghostRects = List<Rect>();
    _pianoRoll.style.addNotificationListener(this);
    _pianoRoll.model.addPianoRollModelListener(this);
  }

  PianoRoll get pianoRoll => _pianoRoll;
  set pianoRoll(PianoRoll pianoRoll) {
    _pianoRoll.style.removeNotificationListener(this);
    _pianoRoll.model.removePianoRollModelListener(this);
    _pianoRoll = pianoRoll;
    _pianoRoll.style.addNotificationListener(this);
    _pianoRoll.model.addPianoRollModelListener(this);
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  Rect computeClipRect() {
    double sx = -_pianoRoll.context.range.scrollOffset.dx;
    double sy = -_pianoRoll.context.range.scrollOffset.dy;
    double w = size.width;
    double h = size.height;
    return Rect.fromLTWH(sx, sy, w, h);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var canvas = context.canvas;

    double sx = _pianoRoll.context.range.scrollOffset.dx;
    double sy = _pianoRoll.context.range.scrollOffset.dy;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(
        offset.dx, offset.dy, size.width + offset.dx, size.height));
    canvas.translate(sx + offset.dx, sy + offset.dy + 50);
    _paintImpl(context, offset);
    canvas.restore();
    // スクロールバーの描画
    canvas.drawRect(
        _pianoRoll.context.horizontalScrollBarRect(
            offset, size.height - 20, size.height, size.width),
        //Rect.fromLTRB(offset.dx, size.height - 20,
        //    offset.dx + (parW * this.size.width), size.height),
        Paint()..color = Color.fromARGB(128, 0, 0, 0));
    offset = offset.translate(0, 50);
    canvas.drawRect(
        _pianoRoll.context.verticalScrollBarRect(offset,
            offset.dx + size.width - 20, offset.dx + size.width, size.height),
        //Rect.fromLTRB(offset.dx + size.width - 20, offset.dy,
        //    offset.dx + size.width, offset.dy + (parH * this.size.height)),
        Paint()..color = Color.fromARGB(128, 0, 0, 0));
  }

  void _paintImpl(PaintingContext context, Offset offset) {
    var canvas = context.canvas;
    var style = _pianoRoll.style;
    var model = _pianoRoll.model;
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
    _drawNoteGhosts(canvas, size);
    if (pianoRoll.context.rectSelectManager.enabled) {
      canvas.drawRect(pianoRoll.context.rectSelectManager.selectionRect,
          Paint()..color = Color.fromARGB(128, 20, 20, 200));
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    var style = _pianoRoll.style;
    var model = _pianoRoll.model;
    int bw = style.beatWidth;
    int bh = style.beatHeight;
    int cw = _pianoRoll.computeMaxWidth();
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
          Offset(_pianoRoll.computeKeyWidth().toDouble(), y.toDouble()),
          _getPaintForKey(KeyColor.black));
      y = nextY;
      index++;
    }
    //*
    canvas.drawLine(
        Offset(0, _pianoRoll.computeMaxHeight().toDouble()),
        Offset(_pianoRoll.computeMaxWidth().toDouble(),
            _pianoRoll.computeMaxHeight().toDouble()),
        _getPaintForKey(KeyColor.black));
    canvas.drawLine(
        Offset(_pianoRoll.computeMaxWidth().toDouble(), 0),
        Offset(_pianoRoll.computeMaxWidth().toDouble(),
            _pianoRoll.computeMaxHeight().toDouble()),
        _getPaintForKey(KeyColor.black));
    //*/
  }

  void _drawKey(Canvas canvas, Size size, P.Key key, int topY, int bottomY) {
    int bw = _pianoRoll.style.beatWidth;
    int bh = _pianoRoll.style.beatHeight;
    int mx = 0;
    for (int i = 0; i < key.measureCount; i++) {
      var m = key.getMeasureAt(i);
      int bx = (bw * m.beatCount) * i;
      for (int j = 0; j < m.beatCount; j++) {
        int nextBx = bx + bw;
        for (int k = 0; k < _pianoRoll.style.beatSplitCount; k++) {
          double lineX = bx + (k * (bw / _pianoRoll.style.beatSplitCount));
          canvas.drawLine(
              Offset(lineX, topY.toDouble()),
              Offset(lineX, bottomY.toDouble()),
              _pianoRoll.style.verticalLinePaint);
        }
        canvas.drawLine(
            Offset(bx.toDouble(), topY.toDouble()),
            Offset(bx.toDouble(), bottomY.toDouble()),
            _pianoRoll.style.verticalLinePaint2);
        bx = nextBx;
      }
      int nextMx = mx + m.beatCount * bw;
      canvas.drawLine(
          Offset(mx.toDouble(), topY.toDouble()),
          Offset(mx.toDouble(), bottomY.toDouble()),
          _pianoRoll.style.verticalHighlightLinePaint);
      mx = nextMx;
    }
  }

  void _drawNotes(Canvas canvas, Size size, P.Key key, int topY, int bottomY,
      bool onionSkin, Color onionSkinColor) {
    int bw = _pianoRoll.style.beatWidth;
    int bh = _pianoRoll.style.beatHeight;
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
              _pianoRoll.computeNoteRect(note, note.offset, note.length),
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
        ? _pianoRoll.style.selectedNotePaint
        : _pianoRoll.style.unselectedNotePaint;
    canvas.drawRect(rect, paint);
    if (!onionSkin) {
      canvas.drawRect(rect, _pianoRoll.style.noteFramePaint1);
      var innerRect = Rect.fromLTRB(rect.left + 1, rect.top + 1,
          rect.left + rect.width - 1, rect.top + rect.height - 1);
      canvas.drawRect(innerRect, _pianoRoll.style.noteFramePaint2);
    }
  }

  void _drawNoteGhosts(Canvas canvas, Size size) {
    var nd = pianoRoll.context.noteDragManager;
    int diffX = nd.currentX - nd.baseX;
    int diffY = nd.currentY - nd.baseY;
    for (var target in nd.targets) {
      var rect =
          pianoRoll.computeNoteRect(target, target.offset, target.length);
      rect = rect.translate(diffX.toDouble(), diffY.toDouble());
      _drawNoteGhost(canvas, size, target, rect);
      _ghostRects.add(rect);
    }
    _ghostRects.clear();
  }

  void _drawNoteGhost(Canvas canvas, Size size, Note note, Rect rect) {
    canvas.drawRect(rect, Paint()..color = Colors.grey);
  }

  Paint _getPaintForKey(KeyColor color) {
    if (color == KeyColor.black) {
      return _pianoRoll.style.blackKeyPaint;
    }
    return _pianoRoll.style.whiteKeyPaint;
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
