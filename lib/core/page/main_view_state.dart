import 'package:flutter/material.dart';
import './main_view.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/piano_roll_editor.dart';
import 'package:next_synth/piano_roll/piano_roll.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_style.dart';
import 'package:next_synth/piano_roll/piano_roll_layout_info.dart';

class MainViewState extends State<MainView> {
  PianoRollModel model;
  PianoRollStyle style;
  PianoRollLayoutInfo layoutInfo;

  MainViewState() {}

  @override
  void initState() {
    super.initState();
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
