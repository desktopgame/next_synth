import 'package:next_synth/piano_roll/piano_roll_utilities.dart';
import './keyboard.dart';
import 'package:flutter/gestures.dart';
import './piano_roll_model_event.dart';
import './piano_roll_model_listener.dart';
import './default_piano_roll_model.dart';
import './piano_roll.dart';
import './piano_roll_model.dart';
import './piano_roll_style.dart';
import 'package:flutter/material.dart';
import './piano_roll_editor.dart';

class PianoRollEdietorState extends State<PianoRollEditor>
    implements PianoRollModelListener {
  final PianoRollModel model;
  final PianoRollStyle style;
  int _scrollAmountX, _scrollAmountY;
  double _scrollX, _scrollY;
  GlobalKey _globalKey = GlobalKey();

  PianoRollEdietorState()
      : this.model = DefaultPianoRollModel(11 * 12, 4, 4),
        this.style = PianoRollStyle() {
    model.addPianoRollModelListener(this);
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
    //1536 2112
    //print('${p.computeMaxWidth()} ${p.computeMaxHeight()}');
    double width = p.computeMaxWidth().toDouble() - (addW);
    double height = p.computeMaxHeight().toDouble() - (addH - 50);
    //print('w=$width h=$height');
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
              double x =
                  details.localPosition.dx + (-style.scrollOffset.dx) - 48;
              double y =
                  details.localPosition.dy + (-style.scrollOffset.dy) - 48;
              PianoRollUtilities.generateOrRemoveAt(p, x, y, 0.25);
            },
            onDoubleTap: () {},
            onDoubleTapCancel: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(top: 0, left: 48),
              child: SizedBox.expand(child: p),
            ),
          )),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              child: k,
              width: 48,
            )),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 50,
            child: Container(
              child: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    onPressed: () {
                      print("push");
                    },
                    child: Icon(Icons.help),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print("push");
                    },
                    child: Icon(Icons.undo),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print("push");
                    },
                    child: Icon(Icons.redo),
                  ),
                  RaisedButton(
                      onPressed: () {
                        print("push");
                      },
                      child: Icon(Icons.save)),
                  Divider(color: Colors.black),
                  RaisedButton(
                      onPressed: () {
                        print("push");
                      },
                      child: Icon(Icons.play_arrow)),
                  RaisedButton(
                      onPressed: () {
                        print("push");
                      },
                      child: Icon(Icons.pause)),
                  RaisedButton(
                      onPressed: () {
                        print("push");
                      },
                      child: Icon(Icons.stop)),
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
