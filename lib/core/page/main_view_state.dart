import 'package:flutter/material.dart';
import './main_view.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/piano_roll_editor.dart';

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [TrackList(), Expanded(child: PianoRollEditor())],
    );
  }
}
