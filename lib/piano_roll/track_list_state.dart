import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/track_list_model.dart';
import 'package:next_synth/piano_roll/default_track_list_model.dart';
import 'package:flutter/material.dart';

class TrackListState extends State<TrackList> {
  TrackListModel _trackListModel;
  int _selectedTrackIndex;
  bool _show;

  TrackListState() {
    this._trackListModel = DefaultTrackListModel();
    this._selectedTrackIndex = -1;
    this._show = true;
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
                    _trackListModel.createTrack();
                  });
                },
                child: Text('+'),
              ),
              RaisedButton(
                onPressed: _trackListModel.size == 0 || _selectedTrackIndex < 0
                    ? null
                    : () {
                        setState(() {
                          _trackListModel.removeTrack(_selectedTrackIndex);
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
                      this._selectedTrackIndex = index;
                    });
                  },
                  selected: _selectedTrackIndex == index,
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
