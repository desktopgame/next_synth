import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:next_synth/core/system/midi_helper.dart';
import 'package:next_synth/core/system/project_list.save_data.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth/piano_roll/default_track_list_model.dart';
import 'package:next_synth/piano_roll/note_play_event.dart';
import 'package:next_synth/piano_roll/note_play_event_type.dart';
import 'package:next_synth/piano_roll/note_play_listener.dart';
import 'package:next_synth/piano_roll/piano_roll_context.dart';
import 'package:next_synth/piano_roll/piano_roll_editor.dart';
import 'package:next_synth/piano_roll/piano_roll_layout_info.dart';
import 'package:next_synth/piano_roll/piano_roll_model.dart';
import 'package:next_synth/piano_roll/piano_roll_model_event.dart';
import 'package:next_synth/piano_roll/piano_roll_model_listener.dart';
import 'package:next_synth/piano_roll/piano_roll_model_provider.dart';
import 'package:next_synth/piano_roll/piano_roll_style.dart';
import 'package:next_synth/piano_roll/track_list.dart';
import 'package:next_synth/piano_roll/track_list_model.dart';
import 'package:next_synth_midi/next_synth_midi.dart';

import './main_view.dart';
import '../system/app_data.save_data.dart';
import '../system/piano_roll_data.dart';
import '../system/project.dart';
import '../system/track_data.dart';

class MainViewState extends State<MainView>
    implements
        PianoRollModelListener,
        NotePlayListener,
        PianoRollModelProvider {
  int _projectIndex;
  int _trackIndex;
  PianoRollContext _context;
  PianoRollLayoutInfo layoutInfo;
  TrackListModel trackListModel;
  List<PianoRollModel> _modelCache;
  final logger = new Logger('MainViewState');

  MainViewState(this._projectIndex) : _modelCache = List<PianoRollModel>() {}

  PianoRollModel get model => _context == null ? null : _context.model;
  PianoRollStyle get style => _context == null ? null : _context.style;

  @override
  void initState() {
    super.initState();
    stopListen();
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    final appData = AppDataProvider.provide().value;
    this.trackListModel = DefaultTrackListModel();
    //this.model = DefaultPianoRollModel(11 * 12, 4, 4);
    var style = PianoRollStyle()
      ..beatWidth = appData.beatWidth
      ..beatHeight = appData.beatHeight
      ..beatSplitCount = appData.beatSplitCount;
    this.layoutInfo = PianoRollLayoutInfo()
      ..toolBarHeight = appData.toolBarHeight.toDouble()
      ..keyboardWidth = appData.keyboardWidth.toDouble();
    PianoRollModel model = null;
    for (var t in proj.tracks) {
      var track = trackListModel.createTrack();
      track.deviceIndex = 0;
      track.name = t.name;
      track.isMute = t.isMute;
      track.model = t.pianoRollData.toModel();
      track.channel = t.channel;
      // プロジェクトを開いたときに必ず0番目が選択状態になるため、対応するモデルを持っておく
      if (model == null) {
        model = track.model.duplicate();
        this._trackIndex = 0;
        model.addPianoRollModelListener(this);
        this._context = PianoRollContext(this, model, style);
        _context.range.scrollOffset = _context.range.scrollOffset
            .translate(0, -appData.beatHeight * ((appData.keyCount / 2) * 12));
      }
    }
    _context.sequencer.addNotePlayListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    stopListen();
    _context.sequencer.removeNotePlayListener(this);
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
        TrackList(trackListModel, onSelected: (index) {
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
        }, onCreated: (t) async {
          var track = TrackData()
            ..deviceIndex = 0
            ..isMute = false
            ..channel = 0
            ..name = _newTrackName(proj)
            ..pianoRollData = PianoRollData.fromModel(DefaultPianoRollModel(
                appData.keyCount * 12,
                appData.measureCount,
                appData.beatCount));
          t.isMute = track.isMute;
          t.deviceIndex = track.deviceIndex;
          t.name = track.name;
          t.channel = track.channel;
          t.model = track.pianoRollData.toModel();
          proj.tracks.add(track);
          await ProjectListProvider.save();
        }, onRemoved: (i) async {
          setState(() {
            _trackIndex = 0;
          });
          proj.tracks.removeAt(i);
          await ProjectListProvider.save();
        }, onUpdated: (i, t) async {
          proj.tracks[i]
            ..deviceIndex = t.deviceIndex
            ..name = t.name
            ..isMute = t.isMute
            ..channel = t.channel;
        }),
        Expanded(child: PianoRollEditor(_context, layoutInfo))
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

  @override
  void notePlay(NotePlayEvent e) {
    if (MidiHelper.instance.devices.length == 0) {
      return;
    }
    final projList = ProjectListProvider.provide().value;
    final proj = projList.data[_projectIndex];
    final track = proj.tracks[e.trackIndex];
    if (track.isMute) {
      return;
    }
    int i = MidiHelper.instance.devices[track.deviceIndex];
    int height = e.note.beat.measure.key.model
        .getKeyHeight(e.note.beat.measure.key.index);
    if (e.type == NotePlayEventType.noteOn) {
      NextSynthMidi.send(
          i, 0, Uint8List.fromList([144 + track.channel, height, 127]), 0, 3);
    } else {
      NextSynthMidi.send(
          i, 0, Uint8List.fromList([128 + track.channel, height, 127]), 0, 3);
    }
  }

  @override
  int get count =>
      ProjectListProvider.provide().value.data[_projectIndex].tracks.length;

  @override
  PianoRollModel getModelAt(int i) {
    if (i == _trackIndex) {
      return _context.mainModel;
    }
    return trackListModel.getTrackAt(i).model;
  }
}
