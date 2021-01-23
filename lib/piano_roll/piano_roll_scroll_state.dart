import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/note_drag_manager.dart';
import 'package:next_synth/piano_roll/note_resize_manager.dart';
import 'package:next_synth/piano_roll/piano_roll_context.dart';
import 'package:next_synth/piano_roll/piano_roll_selection_mode.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';
import 'package:next_synth/piano_roll/rect_select_manager.dart';

import 'piano_roll.dart';
import 'piano_roll_layout_info.dart';
import 'piano_roll_model.dart';
import 'piano_roll_scroll.dart';
import 'piano_roll_style.dart';

class PianoRollScrollState extends State<PianoRollScroll> {
  final PianoRoll pianoRoll;
  final GlobalKey pianoRollKey;
  final PianoRollContext pianoRollContext;
  final PianoRollLayoutInfo layoutInfo;
  final RectSelectManager rectSelectManager;
  final NoteDragManager noteDragManager;
  final NoteResizeManager noteResizeManager;
  int _scrollAmountX, _scrollAmountY;
  double _scrollX, _scrollY;

  PianoRollScrollState(
      this.pianoRoll, this.pianoRollKey, this.pianoRollContext, this.layoutInfo)
      : rectSelectManager = RectSelectManager(),
        noteDragManager = NoteDragManager(pianoRoll),
        noteResizeManager = NoteResizeManager() {
    style.noteDragManager = noteDragManager;
    style.noteResizeManager = noteResizeManager;
    style.rectSelectManager = rectSelectManager;
  }

  PianoRollStyle get style => pianoRollContext.style;
  PianoRollModel get model => pianoRollContext.model;

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
        // ドラッグ中
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
        // 矩形選択中
        if (rectSelectManager.enabled) {
          double x = details.localPosition.dx +
              (-style.scrollOffset.dx) -
              layoutInfo.keyboardWidth;
          double y = details.localPosition.dy +
              (-style.scrollOffset.dy) -
              layoutInfo.toolBarHeight;
          rectSelectManager.rectEnd = Offset(x, y);
          var selRect = rectSelectManager.selectionRect;

          var notes = PianoRollUtilities.getAllNoteList(model).where(
              (element) => selRect.overlaps(pianoRoll.computeNoteRect(
                  element, element.offset, element.length)));
          for (var note in notes) {
            note.selected = true;
          }
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
        if (rectSelectManager.enabled) {
          rectSelectManager.enabled = false;
        }
        style.refresh();
      },
      onVerticalDragStart: (DragStartDetails details) {
        this._scrollAmountY = 0;
        this._scrollY = details.localPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        // ドラッグ中
        if (noteDragManager.hasFocus && !rectSelectManager.enabled) {
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
        // 矩形選択中
        if (rectSelectManager.enabled) {
          double x = details.localPosition.dx +
              (-style.scrollOffset.dx) -
              layoutInfo.keyboardWidth;
          double y = details.localPosition.dy +
              (-style.scrollOffset.dy) -
              layoutInfo.toolBarHeight;
          rectSelectManager.rectEnd = Offset(x, y);
          var selRect = rectSelectManager.selectionRect;

          var notes = PianoRollUtilities.getAllNoteList(model).where(
              (element) => selRect.overlaps(pianoRoll.computeNoteRect(
                  element, element.offset, element.length)));
          for (var note in notes) {
            note.selected = true;
          }
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
        if (rectSelectManager.enabled) {
          rectSelectManager.enabled = false;
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
        // タップ先にノートがあり、選択されていて、既に選択済みのノートがある
        if (notes.length > 0 && (onNotes.length > 0 && onNotes[0].selected)) {
          this.noteDragManager.start(x.toInt(), y.toInt());
          this.noteDragManager.touchAll(notes);
          style.refresh();
          // タップ先にノートがなく、選択モードが矩形選択
        } else if (onNotes.length == 0 &&
            style.selectionMode == PianoRollSelectionMode.rect) {
          rectSelectManager.rectStart = Offset(x.toDouble(), y.toDouble());
          rectSelectManager.rectEnd = Offset(x.toDouble(), y.toDouble());
          rectSelectManager.enabled = true;
          style.refresh();
        }
      },
      onTapUp: (details) {
        if (noteDragManager.hasFocus) {
          noteDragManager.stop();
          return;
        }
        if (rectSelectManager.enabled) {
          rectSelectManager.enabled = false;
          return;
        }
        if (style.selectionMode == PianoRollSelectionMode.tap) {
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
