import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_scroll_state.dart';

import 'piano_roll.dart';
import 'piano_roll_layout_info.dart';
import 'piano_roll_model.dart';
import 'piano_roll_style.dart';

class PianoRollScroll extends StatefulWidget {
  final PianoRoll pianoRoll;
  final GlobalKey pianoRollKey;
  final PianoRollModel model;
  final PianoRollStyle style;
  final PianoRollLayoutInfo layoutInfo;
  PianoRollScroll(this.pianoRoll, this.pianoRollKey, this.model, this.style,
      this.layoutInfo);
  @override
  State<StatefulWidget> createState() {
    return PianoRollEdietorState(
        pianoRoll, pianoRollKey, model, style, layoutInfo);
  }
}
