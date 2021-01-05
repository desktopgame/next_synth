import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';

import './keyboard.dart';
import './piano_roll.dart';
import './piano_roll_editor.dart';
import './piano_roll_layout_info.dart';
import './piano_roll_model.dart';
import './piano_roll_model_event.dart';
import './piano_roll_model_listener.dart';
import './piano_roll_style.dart';
import './reference.dart';

class PianoRollEdietorState extends State<PianoRollEditor>
    implements PianoRollModelListener {
  Reference<PianoRollModel> model;
  PianoRollStyle style;
  PianoRollLayoutInfo layoutInfo;
  int _scrollAmountX, _scrollAmountY;
  double _scrollX, _scrollY;
  GlobalKey _globalKey = GlobalKey();

  PianoRollEdietorState({this.model, this.style, this.layoutInfo}) {
    model.value.addPianoRollModelListener(this);
  }

  void _clampScrollPos(PianoRoll p) {
    if (style.scrollOffset.dx > 0) {
      style.scrollOffset = Offset(0, style.scrollOffset.dy);
    }
    if (style.scrollOffset.dy > 0) {
      style.scrollOffset = Offset(style.scrollOffset.dx, 0);
    }
    RenderBox box = _globalKey.currentContext.findRenderObject();
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
    var p = PianoRoll(model, style, key: _globalKey);
    var k = Keyboard(p);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: (GestureDetector(
            onHorizontalDragStart: (DragStartDetails details) {
              this._scrollAmountX = 0;
              this._scrollX = details.localPosition.dx;
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              style.scrollOffset = style.scrollOffset
                  .translate(-(_scrollX - details.localPosition.dx), 0);
              _clampScrollPos(p);
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
              _clampScrollPos(p);
              this._scrollY = details.localPosition.dy;
              if (_scrollAmountY++ % 10 == 0) {
                style.refresh();
              }
            },
            onVerticalDragEnd: (DragEndDetails details) {
              style.refresh();
            },
            onDoubleTapDown: (details) {
              double x = details.localPosition.dx +
                  (-style.scrollOffset.dx) -
                  layoutInfo.keyboardWidth;
              double y = details.localPosition.dy +
                  (-style.scrollOffset.dy) -
                  layoutInfo.toolBarHeight;
              PianoRollUtilities.generateOrRemoveAt(p, x, y, 0.25);
            },
            onDoubleTap: () {},
            onDoubleTapCancel: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(top: 0, left: layoutInfo.keyboardWidth),
              child: SizedBox.expand(child: p),
            ),
          )),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              child: k,
              width: layoutInfo.keyboardWidth,
            )),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: layoutInfo.toolBarHeight,
            child: Container(
              child: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.help),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.undo),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.redo),
                  ),
                  Divider(color: Colors.black),
                  IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.pause)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.stop)),
                  Text("ProjectName")
                ],
              ),
              color: Colors.cyan,
            ),
          ),
        )
      ],
    );
  }

  @override
  void pianoRollModelUpdate(PianoRollModelEvent e) {}
}
