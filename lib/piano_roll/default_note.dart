import 'package:optional/optional.dart';

import './beat.dart';
import './note.dart';
import './note_event.dart';
import './note_event_type.dart';
import './note_listener.dart';
import '../event/event_listener_list.dart';

class DefaultNote implements Note {
  Beat _beat;
  EventListenerList _listenerList;
  double _length;
  int _offset;
  bool _selected;
  bool _trigger;

  DefaultNote(Beat beat, int offset, double length) {
    this._beat = beat;
    this._offset = offset;
    this._length = length;
    this._listenerList = EventListenerList();
    this._selected = false;
    this._trigger = false;
  }

  @override
  void addNoteListener(NoteListener listener) {
    _listenerList.add(listener);
  }

  @override
  Beat get beat => _beat;

  @override
  set length(double d) {
    var ne = NoteEvent(
        this, NoteEventType.lengthChange, Optional.of(_length), Optional.of(d));
    this._length = d;
    for (NoteListener l in _listenerList.getListeners<NoteListener>()) {
      l.noteChange(ne);
    }
  }

  @override
  double get length => _length;

  @override
  set offset(int i) {
    var ne = NoteEvent(
        this, NoteEventType.offsetChange, Optional.of(_offset), Optional.of(i));
    this._offset = i;
    for (NoteListener l in _listenerList.getListeners<NoteListener>()) {
      l.noteChange(ne);
    }
  }

  @override
  int get offset => _offset;

  @override
  set selected(bool b) {
    if (this._selected == b) {
      return;
    }
    var ne = NoteEvent(this, NoteEventType.selectionChange,
        Optional.of(_selected), Optional.of(b));
    this._selected = b;
    for (NoteListener l in _listenerList.getListeners<NoteListener>()) {
      l.noteChange(ne);
    }
  }

  @override
  bool get selected => _selected;

  @override
  set trigger(bool b) {
    if (this._trigger == b) {
      return;
    }
    var ne = NoteEvent(this, NoteEventType.triggerChange, Optional.of(_trigger),
        Optional.of(b));
    this._trigger = b;
    for (NoteListener l in _listenerList.getListeners<NoteListener>()) {
      l.noteChange(ne);
    }
  }

  @override
  bool get trigger => _trigger;

  @override
  void play() {
    // TODO: implement play
  }

  @override
  void removeFromBeat() {
    var ne = NoteEvent(
        this, NoteEventType.removed, Optional.empty(), Optional.empty());
    for (NoteListener l in _listenerList.getListeners<NoteListener>()) {
      l.noteChange(ne);
    }
  }

  @override
  void removeNoteListener(NoteListener listener) {
    _listenerList.remove(listener);
  }
}
