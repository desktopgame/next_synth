import 'package:flutter/material.dart';
import 'package:next_synth/core/page/main_view_state.dart';

class MainView extends StatefulWidget {
  int _projectIndex;

  MainView(this._projectIndex);

  @override
  State<StatefulWidget> createState() {
    return MainViewState(_projectIndex);
  }
}
