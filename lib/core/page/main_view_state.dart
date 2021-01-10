import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:next_synth/core/system/project_list.save_data.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_track_list_model.dart';
import 'package:next_synth/piano_roll/piano_roll_editor.dart';
import 'package:next_synth/piano_roll/piano_roll_layout_info.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_model_event.dart';
import 'package:next_synth/piano_roll/piano_roll_model_listener.dart';
import 'package:next_synth/piano_roll/piano_roll_style.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/track_list_model.dart';

import './main_view.dart';
import '../system/app_data.save_data.dart';
import '../system/piano_roll_data.dart';
import '../system/project.dart';
import '../system/track_data.dart';

class MainViewState extends State<MainView> implements PianoRollModelListener {
  int _projectIndex;
  int _trackIndex;
  PianoRollModel model;
  PianoRollStyle style;
  PianoRollLayoutInfo layoutInfo;
  TrackListModel trackListModel;
  final logger = new Logger('MainViewState');

  MainViewState(this._projectIndex) {
//    this.model = Reference();
  }

  @override
  void initState() {
    super.initState();
    stopListen();
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    final appData = AppDataProvider.provide().value;
    this.trackListModel = DefaultTrackListModel();
    //this.model = DefaultPianoRollModel(11 * 12, 4, 4);
    this.style = PianoRollStyle()
      ..beatWidth = appData.beatWidth
      ..beatHeight = appData.beatHeight
      ..beatSplitCount = appData.beatSplitCount;
    this.layoutInfo = PianoRollLayoutInfo()
      ..toolBarHeight = appData.toolBarHeight.toDouble()
      ..keyboardWidth = appData.keyboardWidth.toDouble();
    this.model = null;
    for (var t in proj.tracks) {
      var track = trackListModel.createTrack();
      track.name = t.name;
      track.isMute = t.isMute;
      track.model = t.pianoRollData.toModel();
      // プロジェクトを開いたときに必ず0番目が選択状態になるため、対応するモデルを持っておく
      if (this.model == null) {
        this.model = track.model.duplicate();
        this._trackIndex = 0;
        model.addPianoRollModelListener(this);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopListen();
  }

  void stopListen() {
    if (model != null) {
      model.removePianoRollModelListener(this);
    }
  }

  static String _newTrackName(Project proj) {
    var baseName = "NewTrack";
    var name = baseName;
    int i = 1;
    while (proj.tracks.any((element) => element.name == name)) {
      name = '$baseName.$i';
      i++;
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    var appData = AppDataProvider.provide().value;
    return Row(
      children: [
        TrackList(
          trackListModel,
          onSelected: (index) {
            if (!this.mounted) {
              return;
            }
            setState(() {
              stopListen();
              //PianoRollUtilities.getAllNoteList(model).forEach((element) {
              //  element.removeFromBeat();
              //});
              //this.model = proj.tracks[index].pianoRollData.toModel();
              //trackListModel.getTrackAt(index).model = this.model;
              trackListModel.getTrackAt(_trackIndex).model =
                  this.model.duplicate();
              this.model.clear();
              this.model.merge(trackListModel.getTrackAt(index).model);
              //this.model = DefaultPianoRollModel(11 * 12, 4, 4);
              this._trackIndex = index;
              model.addPianoRollModelListener(this);
              style.refresh();
            });
          },
          onCreated: (t) {
            var track = TrackData()
              ..name = _newTrackName(proj)
              ..pianoRollData = PianoRollData.fromModel(DefaultPianoRollModel(
                  appData.keyCount * 12,
                  appData.measureCount,
                  appData.beatCount));
            proj.tracks.add(track);
            t.model = track.pianoRollData.toModel();
          },
          onRemoved: (i) {
            proj.tracks.removeAt(i);
          },
        ),
        Expanded(child: PianoRollEditor(model, style, layoutInfo))
      ],
    );
  }

  @override
  void pianoRollModelUpdate(PianoRollModelEvent e) async {
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    proj.tracks[_trackIndex].pianoRollData = PianoRollData.fromModel(model);
    await ProjectListProvider.save();
  }
}
