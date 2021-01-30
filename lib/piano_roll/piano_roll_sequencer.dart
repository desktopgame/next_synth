import 'dart:async';

import 'package:next_synth/event/event_listener_list.dart';
import 'package:next_synth/piano_roll/note.dart';
import 'package:next_synth/piano_roll/note_play_event.dart';
import 'package:next_synth/piano_roll/note_play_event_type.dart';
import 'package:next_synth/piano_roll/note_play_listener.dart';
import 'package:rxdart/rxdart.dart';

import './piano_roll_ui.dart';
import './update_rate.dart';

class PianoRollSequencer {
  int position;
  int step;
  UpdateRate updateRate;
  void Function() _onTick;
  PianoRollUI _ui;
  Timer _timer;
  bool _isPlaying;
  List<List<Note>> _cachedNotesList;
  EventListenerList _listenerList;
  BehaviorSubject<bool> _playingController;

  Stream<bool> get playingStream => _playingController.stream;

  PianoRollSequencer(this._ui, {void Function() onTick})
      : this._onTick = onTick {
    this.position = 0;
    this.step = 1;
    this.updateRate = UpdateRate.bpmToUpdateRate(480, 120);
    this._isPlaying = false;
    this._playingController = BehaviorSubject();
    this._cachedNotesList = List<List<Note>>();
    this._listenerList = EventListenerList();
  }

  bool get isPlaying => _isPlaying;

  void addNotePlayListener(NotePlayListener listener) {
    _listenerList.add(listener);
  }

  void removeNotePlayListener(NotePlayListener listener) {
    _listenerList.remove(listener);
  }

  void start() {
    int bw = _ui.style.beatWidth;
    int delay = updateRate.computeTimerDelay(bw);
    int stemp = delay;
    this.step = 1;
    while (delay < 32) {
      delay += stemp;
      this.step++;
    }
    print('delay $delay, step $step');
    this._isPlaying = true;
    _playingController.sink.add(true);
    this._timer = Timer.periodic(Duration(milliseconds: delay), _onTime);
    //timer.setInitialDelay(0);
    //timer.setDelay(delay);
  }

  void pause() {
    this._isPlaying = false;
    _playingController.sink.add(false);
    _timer.cancel();
    if (this._onTick != null) {
      this._onTick();
    }
  }

  void stop() {
    this.position = 0;
    if (_isPlaying) {
      this._isPlaying = false;
      _playingController.sink.add(false);
      _timer.cancel();
    }
    if (this._onTick != null) {
      this._onTick();
    }
  }

  void _onTime(Timer timer) {
    for (int i = 0; i < step; i++) {
      _doStep();
    }
    if (this._onTick != null) {
      this._onTick();
    }
  }

  void _doStep() {
    this.position++;
    for (int p = 0; p < _ui.provider.count; p++) {
      _ui.swapModel(p);
      if (_cachedNotesList.length <= p) {
        _cachedNotesList.add(List<Note>());
      }
      var _cachedNotes = _cachedNotesList[p];
      //int index = _ui.computeRelativeBeatIndex(this.position.toDouble());
      var allNotes = List<Note>();
      for (int y = 0; y < _ui.computeMaxHeight(); y += _ui.style.beatHeight) {
        var sub = _ui.getNotesAt(this.position.toDouble(), y.toDouble());
        allNotes.addAll(sub);
      }
      var notes = List<Note>()
        ..addAll(allNotes)
        ..toSet()
        ..toList();
      for (Note note in notes) {
        if (!_cachedNotes.contains(note)) {
          _fireNotePlay(p, note, NotePlayEventType.noteOn);
        }
      }
      var noteOffList =
          _cachedNotes.where((element) => !notes.contains(element));
      for (Note note in noteOffList) {
        _fireNotePlay(p, note, NotePlayEventType.noteOff);
      }
      _cachedNotes.removeWhere((element) => !notes.contains(element));
      _cachedNotes.addAll(notes);
      _cachedNotes = _cachedNotes.toSet().toList();
      _cachedNotesList[p].clear();
      _cachedNotesList[p].addAll(_cachedNotes);
    }
    _ui.swapModel(-1);
  }

  void _fireNotePlay(int trackIndex, Note note, NotePlayEventType type) {
    var evt = NotePlayEvent(this, trackIndex, note, type);
    for (NotePlayListener listener
        in _listenerList.getListeners<NotePlayListener>()) {
      listener.notePlay(evt);
    }
  }
}
