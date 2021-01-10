import 'package:flutter/material.dart';

import './tool_bar_state.dart';
import 'piano_roll_model.dart';

class ToolBar extends StatefulWidget {
  final PianoRollModel _model;

  ToolBar(this._model);

  @override
  State<StatefulWidget> createState() {
    return ToolBarState(_model);
  }
}
