import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/track.dart';
import './track_list_state.dart';
import './track_list_model.dart';

class TrackList extends StatefulWidget {
  TrackListModel _trackListModel;
  void Function(int) _onSelected;
  void Function(Track) _onCreated;
  void Function(int) _onRemoved;

  TrackList(this._trackListModel,
      {void Function(int) onSelected,
      void Function(Track) onCreated,
      void Function(int) onRemoved}) {
    this._onSelected = onSelected;
    this._onCreated = onCreated;
    this._onRemoved = onRemoved;
  }

  @override
  State<StatefulWidget> createState() {
    return TrackListState(_trackListModel,
        onSelected: _onSelected, onCreated: _onCreated, onRemoved: _onRemoved);
  }
}
