import 'dart:math';

import 'package:next_synth/piano_roll/note_drag_listener.dart';
import 'package:next_synth/piano_roll/piano_roll.dart';

import './note.dart';
import './note_drag_event.dart';
import './note_drag_listener.dart';
import '../event/event_listener_list.dart';
import './piano_roll_ui.dart';

class NoteDragManager {
  PianoRollUI _pianoRollUI;
  List<Note> _dragTargets;
  int _baseX;
  int _baseY;
  int _currentX;
  int _currentY;
  bool _hasFocus;
  EventListenerList _listenerList;
  Note _baseNote;

  NoteDragManager(this._pianoRollUI) {
    this._dragTargets = List<Note>();
    this._baseX = 0;
    this._baseY = 0;
    this._currentX = 0;
    this._currentY = 0;
    this._hasFocus = false;
    this._listenerList = EventListenerList();
  }

  List<Note> get targets => List<Note>()..addAll(_dragTargets);
  bool get hasFocus => _hasFocus;
  int get baseX => _baseX;
  int get baseY => _baseY;
  int get currentX => _currentX;
  int get currentY => _currentY;
  Note get baseNote => _baseNote;

  void addNoteDragListener(NoteDragListener listener) {
    _listenerList.add(listener);
  }

  void removeNoteDragListener(NoteDragListener listener) {
    _listenerList.remove(listener);
  }

  void touch(Note note) {
    _dragTargets.add(note);
    this._baseNote = note;
  }

  void touchAll(List<Note> notes) {
    _dragTargets.addAll(notes);
    if (notes.isNotEmpty) {
      this._baseNote = notes[notes.length - 1];
    }
  }

  void clear() {
    _dragTargets.clear();
  }

  void start(int baseX, int baseY) {
    this._dragTargets = _dragTargets.toSet().toList();
    this._baseX = baseX;
    this._baseY = baseY;
    this._currentX = baseX;
    this._currentY = baseY;
    this._hasFocus = true;
    var e = NoteDragEvent(this);
    for (NoteDragListener listener
        in _listenerList.getListeners<NoteDragListener>()) {
      listener.dragStart(e);
    }
  }

  void move(int x, int y) {
    this._currentX = max(x, 0);
    this._currentY = max(y, 0);
  }

  void stop() {
    int diffX = (_currentX - _baseX);
    int diffY = (_currentY - _baseY);
    for (Note note in _dragTargets) {
      var rect = _pianoRollUI.computeNoteRect(note, note.offset, note.length);
      rect = rect.translate(diffX.toDouble(), diffY.toDouble());
      var measureOpt = _pianoRollUI.getMeasureAt(rect.left, rect.top);
      measureOpt.ifPresent((measure) {
        double xOffset = _pianoRollUI.measureIndexToXOffset(measure.index);
        xOffset += _pianoRollUI.style.beatWidth *
            _pianoRollUI.computeRelativeBeatIndex(rect.left);
        measure
            .getBeatAt(_pianoRollUI.computeRelativeBeatIndex(rect.left))
            .generateNote((rect.left - xOffset).toInt(), note.length);
      });
      if (measureOpt.isPresent) {
        note.removeFromBeat();
      }
    }
    _dragTargets.clear();
    this._hasFocus = false;
    this._baseNote = null;
    var e = NoteDragEvent(this);
    for (NoteDragListener listener
        in _listenerList.getListeners<NoteDragListener>()) {
      listener.dragEnd(e);
    }
  }
}
