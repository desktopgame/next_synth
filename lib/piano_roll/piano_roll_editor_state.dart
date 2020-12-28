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
  PianoRollModel _model;
  PianoRollStyle _style;
  int _scrollAmountX, _scrollAmountY;
  double _scrollX, _scrollY;
  GlobalKey _globalKey = GlobalKey();

  PianoRollEdietorState() {
    this._model = DefaultPianoRollModel(11 * 12, 4, 4);
    this._style = PianoRollStyle();
    _model.addPianoRollModelListener(this);
  }

  void _clampScrollPos(PianoRoll p) {
    if (_style.scrollOffset.dx > 0) {
      _style.scrollOffset = Offset(0, _style.scrollOffset.dy);
    }
    if (_style.scrollOffset.dy > 0) {
      _style.scrollOffset = Offset(_style.scrollOffset.dx, 0);
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
    if (_style.scrollOffset.dx < -width) {
      _style.scrollOffset = Offset(-width, _style.scrollOffset.dy);
    }
    if (_style.scrollOffset.dy < -height) {
      _style.scrollOffset = Offset(_style.scrollOffset.dx, -height);
    }
    _style.scrollOffset =
        Offset(_style.scrollOffset.dx, _style.scrollOffset.dy);
  }

  @override
  Widget build(BuildContext context) {
    var p = PianoRoll(_model, _style, key: _globalKey);
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
              _style.scrollOffset = _style.scrollOffset
                  .translate(-(_scrollX - details.localPosition.dx), 0);
              _clampScrollPos(p);
              this._scrollX = details.localPosition.dx;
              if (_scrollAmountX++ % 10 == 0) {
                _style.refresh();
              }
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              _style.refresh();
            },
            onVerticalDragStart: (DragStartDetails details) {
              this._scrollAmountY = 0;
              this._scrollY = details.localPosition.dy;
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              _style.scrollOffset = _style.scrollOffset
                  .translate(0, -(_scrollY - details.localPosition.dy));
              _clampScrollPos(p);
              this._scrollY = details.localPosition.dy;
              if (_scrollAmountY++ % 10 == 0) {
                _style.refresh();
              }
            },
            onVerticalDragEnd: (DragEndDetails details) {
              _style.refresh();
            },
            onDoubleTapDown: (details) {
              double x =
                  details.localPosition.dx + (-_style.scrollOffset.dx) - 48;
              double y =
                  details.localPosition.dy + (-_style.scrollOffset.dy) - 48;
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
