import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_context.dart';
import 'package:next_synth/piano_roll/piano_roll_scroll_state.dart';

import 'piano_roll.dart';
import 'piano_roll_layout_info.dart';

class PianoRollScroll extends StatefulWidget {
  final PianoRoll pianoRoll;
  final GlobalKey pianoRollKey;
  final PianoRollContext context;
  final PianoRollLayoutInfo layoutInfo;
  PianoRollScroll(
      this.pianoRoll, this.pianoRollKey, this.context, this.layoutInfo);
  @override
  State<StatefulWidget> createState() {
    return PianoRollScrollState(pianoRoll, pianoRollKey, context, layoutInfo);
  }
}
