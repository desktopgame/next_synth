import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_synth/core/system/midi_helper.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/track_list_model.dart';
import '../core/system/app_data.save_data.dart';

import './track.dart';

class TrackListState extends State<TrackList> {
  TrackListModel _trackListModel;
  int _selectedTrackIndex;
  bool _show;
  void Function(int) _onSelected;
  void Function(Track) _onCreated;
  void Function(int) _onRemoved;
  void Function(int, Track) _onUpdated;

  TrackListState(this._trackListModel,
      {void Function(int) onSelected,
      void Function(Track) onCreated,
      void Function(int) onRemoved,
      void Function(int, Track) onUpdated}) {
    this.selectedTrackIndex = -1;
    this._show = true;
    if (this._trackListModel.size > 0) {
      this.selectedTrackIndex = 0;
    }
    this._onSelected = onSelected;
    this._onCreated = onCreated;
    this._onRemoved = onRemoved;
    this._onUpdated = onUpdated;
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
              color: AppDataProvider.provide().value.darkTheme
                  ? Colors.black
                  : Colors.cyan,
              border: Border.all(
                style: BorderStyle.solid,
                color: AppDataProvider.provide().value.darkTheme
                    ? Colors.black
                    : Colors.white,
              )),
          //color: Colors.cyan,
          height: 50,
          child: ButtonBar(
            children: [
              ElevatedButton(
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
              ElevatedButton(
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
        ElevatedButton(
          onPressed: _trackListModel.size == 0
              ? null
              : () {
                  _showTrackEditDialog(selectedTrackIndex);
                },
          child: Text('トラックの詳細設定'),
        ),
        ElevatedButton(
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

  Widget _labelWith(String label, Widget widget) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              label,
              textAlign: TextAlign.center,
            )),
        Expanded(child: widget)
      ],
    );
  }

  Widget _inputString(String name, String hint, bool readonly,
      TextEditingController controller, void Function(String) onChanged) {
    return _labelWith(
        name,
        TextField(
          readOnly: readonly,
          controller: controller,
          decoration: new InputDecoration(labelText: hint),
          onChanged: onChanged,
        ));
  }

  Widget _inputInt(String name, String hint, bool readonly,
      TextEditingController controller, void Function(String) onChanged) {
    return _labelWith(
        name,
        TextField(
          readOnly: readonly,
          controller: controller,
          decoration: new InputDecoration(labelText: hint),
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ));
  }

  Widget _inputBool(String name, bool value, void Function(bool) onChanged) {
    return _labelWith(
        name,
        Switch(
          value: value,
          onChanged: onChanged,
        ));
  }

  void _showTrackEditDialog(int trackIndex) {
    var track = _trackListModel.getTrackAt(trackIndex);
    var nameController = TextEditingController()..text = track.name;
    var dvController = TextEditingController()
      ..text = track.deviceIndex.toString();
    var chController = TextEditingController()..text = track.channel.toString();
    var connections = MidiHelper.instance.getConnections();
    var decoColor = AppDataProvider.provide().value.darkTheme
        ? Colors.black
        : Colors.lightBlue;
    showDialog(
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                    child: Container(
                  width: double.infinity,
                  height: 380,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: decoColor),
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    children: [
                      _inputString("名前", "", false, nameController, (e) {
                        setState(() {
                          track.name = e;
                          _onUpdated(_selectedTrackIndex, track);
                        });
                      }),
                      StatefulBuilder(builder: (context, setState) {
                        if (connections.length == 0) {
                          return _labelWith(
                              "デバイス番号", Text("MIDI機器が接続されていません。"));
                        }
                        return _labelWith(
                            "デバイス番号",
                            DropdownButton<int>(
                              value: track.deviceIndex,
                              onChanged: (int newValue) {
                                setState(() {
                                  track.deviceIndex = newValue;
                                  _onUpdated(_selectedTrackIndex, track);
                                });
                              },
                              items: connections.map((DeviceConnection item) {
                                return DropdownMenuItem(
                                  value: item.deviceIndex,
                                  child: Text(
                                    item.name,
                                    style: item.deviceIndex == track.deviceIndex
                                        ? TextStyle(fontWeight: FontWeight.bold)
                                        : TextStyle(
                                            fontWeight: FontWeight.normal),
                                  ),
                                );
                              }).toList(),
                            ));
                      }),
                      /*
                      _inputInt("デバイス番号", "", false, dvController, (e) {
                        setState(() {
                          track.deviceIndex = int.parse(e);
                          _onUpdated(_selectedTrackIndex, track);
                        });
                      }),
                      */
                      _inputInt("チャンネル(1~16)", "", false, chController, (e) {
                        setState(() {
                          track.channel = int.parse(e);
                          _onUpdated(_selectedTrackIndex, track);
                        });
                      }),
                      StatefulBuilder(builder: (context, setState) {
                        return _inputBool("ミュート", track.isMute, (e) {
                          setState(() {
                            track.isMute = e;
                            _onUpdated(_selectedTrackIndex, track);
                          });
                        });
                      }),
                      new TextButton(
                        child: new Text("閉じる"),
                        onPressed: () {
                          //onApprrove(controller);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ))
              ],
            ),
          );
        },
        context: context);
  }
}
