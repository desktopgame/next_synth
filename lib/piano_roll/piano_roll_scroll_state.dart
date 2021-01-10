import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';

import 'piano_roll.dart';
import 'piano_roll_layout_info.dart';
import 'piano_roll_model.dart';
import 'piano_roll_scroll.dart';
import 'piano_roll_style.dart';

class PianoRollEdietorState extends State<PianoRollScroll> {
  PianoRoll pianoRoll;
  GlobalKey pianoRollKey;
  PianoRollModel model;
  PianoRollStyle style;
  PianoRollLayoutInfo layoutInfo;
  int _scrollAmountX, _scrollAmountY;
  double _scrollX, _scrollY;

  PianoRollEdietorState(this.pianoRoll, this.pianoRollKey, this.model,
      this.style, this.layoutInfo) {}

  void _clampScrollPos(PianoRoll p) {
    if (style.scrollOffset.dx > 0) {
      style.scrollOffset = Offset(0, style.scrollOffset.dy);
    }
    if (style.scrollOffset.dy > 0) {
      style.scrollOffset = Offset(style.scrollOffset.dx, 0);
    }
    RenderBox box = pianoRollKey.currentContext.findRenderObject();
    double addW = 0;
    double addH = 0;
    if (box != null) {
      addW = box.size.width;
      addH = box.size.height;
    }
    double width = p.computeMaxWidth().toDouble() - (addW);
    double height =
        p.computeMaxHeight().toDouble() - (addH - layoutInfo.toolBarHeight);
    if (style.scrollOffset.dx < -width) {
      style.scrollOffset = Offset(-width, style.scrollOffset.dy);
    }
    if (style.scrollOffset.dy < -height) {
      style.scrollOffset = Offset(style.scrollOffset.dx, -height);
    }
    style.scrollOffset = Offset(style.scrollOffset.dx, style.scrollOffset.dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        this._scrollAmountX = 0;
        this._scrollX = details.localPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        style.scrollOffset = style.scrollOffset
            .translate(-(_scrollX - details.localPosition.dx), 0);
        _clampScrollPos(pianoRoll);
        this._scrollX = details.localPosition.dx;
        if (_scrollAmountX++ % 10 == 0) {
          style.refresh();
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        style.refresh();
      },
      onVerticalDragStart: (DragStartDetails details) {
        this._scrollAmountY = 0;
        this._scrollY = details.localPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        style.scrollOffset = style.scrollOffset
            .translate(0, -(_scrollY - details.localPosition.dy));
        _clampScrollPos(pianoRoll);
        this._scrollY = details.localPosition.dy;
        if (_scrollAmountY++ % 10 == 0) {
          style.refresh();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        style.refresh();
      },
      onTapDown: (details) {},
      onTapUp: (details) {
        double x = details.localPosition.dx +
            (-style.scrollOffset.dx) -
            layoutInfo.keyboardWidth;
        double y = details.localPosition.dy +
            (-style.scrollOffset.dy) -
            layoutInfo.toolBarHeight;
        var notes = pianoRoll.getNotesAt(x, y);
        if (notes.isNotEmpty) {
          notes[0].selected = !notes[0].selected;
        }
      },
      onDoubleTapDown: (details) {
        double x = details.localPosition.dx +
            (-style.scrollOffset.dx) -
            layoutInfo.keyboardWidth;
        double y = details.localPosition.dy +
            (-style.scrollOffset.dy) -
            layoutInfo.toolBarHeight;
        PianoRollUtilities.generateOrRemoveAt(pianoRoll, x, y, 0.25);
      },
      onDoubleTap: () {},
      onDoubleTapCancel: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(top: 0, left: layoutInfo.keyboardWidth),
        child: SizedBox.expand(child: pianoRoll),
      ),
    );
  }
}
