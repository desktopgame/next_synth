import 'package:next_synth/piano_roll/piano_roll_editor_state.dart';

import './piano_roll_model.dart';
import './piano_roll_style.dart';
import './piano_roll.dart';
import './piano_roll_layout_info.dart';
import 'package:flutter/material.dart';
import './reference.dart';

class PianoRollEditor extends StatefulWidget {
  final Reference<PianoRollModel> model;
  final PianoRollStyle style;
  final PianoRollLayoutInfo layoutInfo;
  PianoRollEditor({this.model, this.style, this.layoutInfo});
  @override
  State<StatefulWidget> createState() {
    return PianoRollEdietorState(
        model: model, style: style, layoutInfo: layoutInfo);
  }
}
