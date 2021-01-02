import 'package:flutter/material.dart';
import 'package:next_synth/core/system/project_list.save_data.dart';
import './main_view.dart';
import '../system/app_data.dart';
import '../system/app_data.save_data.dart';
import '../system/piano_roll_data.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/piano_roll_editor.dart';
import 'package:next_synth/piano_roll/piano_roll.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_style.dart';
import 'package:next_synth/piano_roll/piano_roll_layout_info.dart';
import 'package:logging/logging.dart';
import 'package:next_synth/piano_roll/track_list_model.dart';
import 'package:next_synth/piano_roll/default_track_list_model.dart';
import '../system/track_data.dart';
import '../system/project.dart';

class MainViewState extends State<MainView> {
  int _projectIndex;
  PianoRollModel model;
  PianoRollStyle style;
  PianoRollLayoutInfo layoutInfo;
  TrackListModel trackListModel;
  final logger = new Logger('MainViewState');

  MainViewState(this._projectIndex) {}

  @override
  void initState() {
    super.initState();
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    debugPrint("MainViewState: ${_projectIndex}=${proj.name}");
    this.trackListModel = DefaultTrackListModel();
    //this.model = DefaultPianoRollModel(11 * 12, 4, 4);
    this.style = PianoRollStyle();
    this.layoutInfo = PianoRollLayoutInfo();
    for (var t in proj.tracks) {
      var track = trackListModel.createTrack();
      track.name = t.name;
      track.isMute = t.isMute;
      track.model = t.pianoRollData.toModel();
      // プロジェクトを開いたときに必ず0番目が選択状態になるため、対応するモデルを持っておく
      if (this.model == null) {
        this.model = track.model;
      }
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
            this.model = proj.tracks[index].pianoRollData.toModel();
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
