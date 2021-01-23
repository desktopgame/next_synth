import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/keyboard.dart';

import './key_color.dart';
import './key_table.dart';

class KeyboardRenderBox extends RenderBox {
  final Keyboard _keyboard;

  KeyboardRenderBox(this._keyboard);

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _paintImpl(context, offset);
  }

  void _paintImpl(PaintingContext context, Offset offset) {
    //offset = Offset(0, 0);
    var canvas = context.canvas;
    var p = _keyboard.pianoRoll;
    var pModel = p.model;
    int bw = p.style.beatWidth;
    int bh = p.style.beatHeight;
    int y = p.context.range.scrollOffset.dy.toInt() + 50;
    for (int i = pModel.keyCount - 1; i >= 0; i--) {
      var k = pModel.getKeyAt(i);
      int nextY = y + bh;
      int indexInBwTable = i % KeyTable.basic.length;
      if (KeyTable.basic.colors[indexInBwTable] == KeyColor.black) {
        canvas.drawRect(
            Rect.fromLTWH(offset.dx, y.toDouble(), 48, (nextY - y).toDouble()),
            Paint()..color = Color.fromARGB(255, 64, 64, 64));
      } else {
        canvas.drawRect(
            Rect.fromLTWH(offset.dx, y.toDouble(), 48, (nextY - y).toDouble()),
            Paint()..color = Color.fromARGB(255, 192, 192, 192));
      }
      canvas.drawLine(Offset(offset.dx, y.toDouble()),
          Offset(offset.dx + 48, y.toDouble()), Paint()..color = Colors.black);
      y = nextY;
    }
    y = p.context.range.scrollOffset.dy.toInt() + 50;
    for (int i = pModel.keyCount - 1; i >= 0; i--) {
      var k = pModel.getKeyAt(i);
      int indexInBwTable = i % KeyTable.basic.length;
      int nextY = y + bh;
      if (KeyTable.names[indexInBwTable] == "C") {
        int octave = k.index ~/ KeyTable.names.length;
        var span = new TextSpan(
            style: new TextStyle(color: Colors.blue), text: '${octave}C');
        var tp = new TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(offset.dx, y.toDouble()));
      }
      y = nextY;
    }
  }
}
