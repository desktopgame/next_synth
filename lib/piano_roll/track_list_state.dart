import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/track_list_model.dart';
import 'package:next_synth/piano_roll/default_track_list_model.dart';
import 'package:flutter/material.dart';
import './track.dart';

class TrackListState extends State<TrackList> {
  TrackListModel _trackListModel;
  int _selectedTrackIndex;
  bool _show;
  void Function(int) _onSelected;
  void Function(Track) _onCreated;
  void Function(int) _onRemoved;

  TrackListState(this._trackListModel,
      {void Function(int) onSelected,
      void Function(Track) onCreated,
      void Function(int) onRemoved}) {
    this.selectedTrackIndex = -1;
    this._show = true;
    if (this._trackListModel.size > 0) {
      this.selectedTrackIndex = 0;
    }
    this._onSelected = onSelected;
    this._onCreated = onCreated;
    this._onRemoved = onRemoved;
  }

  int get selectedTrackIndex => _selectedTrackIndex;
  set selectedTrackIndex(int i) {
    this._selectedTrackIndex = i;
    if (_onSelected != null) {
      _onSelected(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_show) {
      return GestureDetector(
          onTap: () {
            setState(() {
              _show = true;
            });
          },
          child: SizedBox(
            width: 40,
            child: Container(
              color: Colors.lime,
            ),
          ));
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.cyan,
              border:
                  Border.all(style: BorderStyle.solid, color: Colors.white)),
          //color: Colors.cyan,
          height: 50,
          child: ButtonBar(
            children: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    var track = _trackListModel.createTrack();
                    if (this._onCreated != null) {
                      _onCreated(track);
                    }
                  });
                },
                child: Text('+'),
              ),
              RaisedButton(
                onPressed: _trackListModel.size == 1 || selectedTrackIndex < 0
                    ? null
                    : () {
                        setState(() {
                          _trackListModel.removeTrack(selectedTrackIndex);
                          if (this._onRemoved != null) {
                            _onRemoved(selectedTrackIndex);
                          }
                          if (selectedTrackIndex > 0) {
                            selectedTrackIndex--;
                          }
                        });
                      },
                child: Text('-'),
              )
            ],
          ),
        ),
        Expanded(
            child: SizedBox(
          width: 120,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  onTap: () {
                    setState(() {
                      this.selectedTrackIndex = index;
                    });
                  },
                  selected: selectedTrackIndex == index,
                  title: Text('${_trackListModel.getTrackAt(index).name}'));
            },
            itemCount: _trackListModel.size,
          ),
        )),
        RaisedButton(
          onPressed: _trackListModel.size == 0 ? null : () {},
          child: Text('トラックの詳細設定'),
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              this._show = false;
            });
          },
          child: Text('サイドバーを閉じる'),
        )
      ],
    );
  }
}
