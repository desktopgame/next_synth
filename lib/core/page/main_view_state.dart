import 'package:flutter/material.dart';
import 'package:next_synth/core/system/project_list.save_data.dart';
import './main_view.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/piano_roll_editor.dart';
import 'package:next_synth/piano_roll/piano_roll.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_style.dart';
import 'package:next_synth/piano_roll/piano_roll_layout_info.dart';
import 'package:logging/logging.dart';

class MainViewState extends State<MainView> {
  int _projectIndex;
  PianoRollModel model;
  PianoRollStyle style;
  PianoRollLayoutInfo layoutInfo;
  final logger = new Logger('MainViewState');

  MainViewState(this._projectIndex) {}

  @override
  void initState() {
    super.initState();
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    debugPrint("MainViewState: ${_projectIndex}=${proj.name}");
    this.model = DefaultPianoRollModel(11 * 12, 4, 4);
    this.style = PianoRollStyle();
    this.layoutInfo = PianoRollLayoutInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TrackList(),
        Expanded(
            child: PianoRollEditor(
          model: model,
          style: style,
          layoutInfo: layoutInfo,
        ))
      ],
    );
  }
}
