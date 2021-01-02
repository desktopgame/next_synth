import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/track.dart';
import './track_list_state.dart';
import './track_list_model.dart';

class TrackList extends StatefulWidget {
  TrackListModel _trackListModel;

  TrackList(this._trackListModel);

  @override
  State<StatefulWidget> createState() {
    return TrackListState(_trackListModel);
  }
}
