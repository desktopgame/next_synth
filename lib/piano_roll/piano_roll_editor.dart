import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_context.dart';
import 'package:next_synth/piano_roll/piano_roll_scroll.dart';

import './keyboard.dart';
import './piano_roll.dart';
import './piano_roll_layout_info.dart';
import './tool_bar.dart';

class PianoRollEditor extends StatelessWidget {
  final PianoRollContext _context;
  final PianoRollLayoutInfo _layoutInfo;
  final GlobalKey _pianoRollKey = GlobalKey();

  PianoRollEditor(this._context, this._layoutInfo);

  @override
  Widget build(BuildContext context) {
    var p = PianoRoll(_context, key: _pianoRollKey);
    var k = Keyboard(p);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: PianoRollScroll(p, _pianoRollKey, _context, _layoutInfo),
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
            child: ToolBar(_context),
          ),
        )
      ],
    );
  }
}
