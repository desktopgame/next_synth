import 'package:flutter/material.dart';

import './tool_bar_state.dart';
import 'piano_roll_model.dart';
import 'piano_roll_style.dart';

class ToolBar extends StatefulWidget {
  final PianoRollModel _model;
  final PianoRollStyle _style;

  ToolBar(this._model, this._style);

  @override
  State<StatefulWidget> createState() {
    return ToolBarState(_model, _style);
  }
}
