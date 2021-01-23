import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/piano_roll_context.dart';

import './tool_bar_state.dart';

class ToolBar extends StatefulWidget {
  final PianoRollContext _context;

  ToolBar(this._context);

  @override
  State<StatefulWidget> createState() {
    return ToolBarState(_context);
  }
}
