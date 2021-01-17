import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/note_drag_manager.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';

import 'piano_roll.dart';
import 'piano_roll_layout_info.dart';
import 'piano_roll_model.dart';
import 'piano_roll_scroll.dart';
import 'piano_roll_style.dart';

class PianoRollEdietorState extends State<PianoRollScroll> {
  final PianoRoll pianoRoll;
  final GlobalKey pianoRollKey;
  final PianoRollModel model;
  final PianoRollStyle style;
  final PianoRollLayoutInfo layoutInfo;
  final NoteDragManager noteDragManager;
  int _scrollAmountX, _scrollAmountY;
  double _scrollX, _scrollY;

  PianoRollEdietorState(this.pianoRoll, this.pianoRollKey, this.model,
      this.style, this.layoutInfo)
      : noteDragManager = NoteDragManager(pianoRoll) {
    style.noteDragManager = noteDragManager;
  }

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
        if (noteDragManager.hasFocus) {
          double x = details.localPosition.dx +
              (-style.scrollOffset.dx) -
              layoutInfo.keyboardWidth;
          double y = details.localPosition.dy +
              (-style.scrollOffset.dy) -
              layoutInfo.toolBarHeight;
          noteDragManager.move(x.toInt(), y.toInt());
          style.refresh();
          return;
        }
        style.scrollOffset = style.scrollOffset
            .translate(-(_scrollX - details.localPosition.dx), 0);
        _clampScrollPos(pianoRoll);
        this._scrollX = details.localPosition.dx;
        if (_scrollAmountX++ % 10 == 0) {
          style.refresh();
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (noteDragManager.hasFocus) {
          noteDragManager.stop();
        }
        style.refresh();
      },
      onVerticalDragStart: (DragStartDetails details) {
        this._scrollAmountY = 0;
        this._scrollY = details.localPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (noteDragManager.hasFocus) {
          double x = details.localPosition.dx +
              (-style.scrollOffset.dx) -
              layoutInfo.keyboardWidth;
          double y = details.localPosition.dy +
              (-style.scrollOffset.dy) -
              layoutInfo.toolBarHeight;
          noteDragManager.move(x.toInt(), y.toInt());
          style.refresh();
          return;
        }
        style.scrollOffset = style.scrollOffset
            .translate(0, -(_scrollY - details.localPosition.dy));
        _clampScrollPos(pianoRoll);
        this._scrollY = details.localPosition.dy;
        if (_scrollAmountY++ % 10 == 0) {
          style.refresh();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        if (noteDragManager.hasFocus) {
          noteDragManager.stop();
        }
        style.refresh();
      },
      onTapDown: (details) {
        double x = details.localPosition.dx +
            (-style.scrollOffset.dx) -
            layoutInfo.keyboardWidth;
        double y = details.localPosition.dy +
            (-style.scrollOffset.dy) -
            layoutInfo.toolBarHeight;
        var notes = PianoRollUtilities.getAllNoteList(model)
            .where((element) => element.selected)
            .toList();
        var onNotes = pianoRoll.getNotesAt(x, y);
        if (notes.length > 0 && (onNotes.length > 0 && onNotes[0].selected)) {
          this.noteDragManager.start(x.toInt(), y.toInt());
          this.noteDragManager.touchAll(notes);
          style.refresh();
        }
      },
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
