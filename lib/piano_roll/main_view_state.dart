import 'package:flutter/material.dart';
import './main_view.dart';
import './track_list.dart';
import './piano_roll_editor.dart';

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    //*
    return Row(
      children: [TrackList(), Expanded(child: PianoRollEditor())],
    );

    //  */
/*
    return Stack(
      children: [
        Align(alignment: Alignment.centerRight, child: PianoRollEditor()),
        Align(
          alignment: Alignment.topLeft,
          child: TrackList(),
        ),
      ],
    );
    */
  }
}
