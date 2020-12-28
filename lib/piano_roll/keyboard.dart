import 'package:flutter/material.dart';
import './keyboard_render_box.dart';
import './piano_roll.dart';

class Keyboard extends SingleChildRenderObjectWidget {
  final PianoRoll _pianoRoll;

  Keyboard(this._pianoRoll);

  PianoRoll get pianoRoll => _pianoRoll;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return KeyboardRenderBox(this);
  }
}
