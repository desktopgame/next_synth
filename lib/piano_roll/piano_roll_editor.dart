import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_scroll.dart';

import './keyboard.dart';
import './piano_roll.dart';
import './piano_roll_layout_info.dart';
import './piano_roll_model.dart';
import './piano_roll_style.dart';
import './tool_bar.dart';

class PianoRollEditor extends StatelessWidget {
  PianoRollModel _model;
  PianoRollStyle _style;
  PianoRollLayoutInfo _layoutInfo;
  GlobalKey _pianoRollKey = GlobalKey();

  PianoRollEditor(this._model, this._style, this._layoutInfo);

  @override
  Widget build(BuildContext context) {
    var p = PianoRoll(_model, _style, key: _pianoRollKey);
    var k = Keyboard(p);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: PianoRollScroll(p, _pianoRollKey, _model, _style, _layoutInfo),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              child: k,
              width: _layoutInfo.keyboardWidth,
            )),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: _layoutInfo.toolBarHeight,
            child: ToolBar(_model),
          ),
        )
      ],
    );
  }
}
