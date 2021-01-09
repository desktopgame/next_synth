import 'package:optional/optional.dart';

import './beat.dart';
import './beat_event.dart';
import './beat_event_type.dart';
import './beat_listener.dart';
import './default_note.dart';
import './measure.dart';
import './note.dart';
import './note_event.dart';
import './note_event_type.dart';
import './note_listener.dart';
import '../event/event_listener_list.dart';

class DefaultBeat implements Beat, NoteListener {
  Measure _measure;
  int _index;
  List<Note> _noteList;
  EventListenerList _listenerList;

  DefaultBeat(Measure measure, int index) {
    this._measure = measure;
    this._index = index;
    this._noteList = List<Note>();
    this._listenerList = EventListenerList();
  }

  @override
  void addBeatListener(BeatListener listener) {
    _listenerList.add(listener);
  }

  @override
  Note generateNote(int offset, double length) {
    var note = createNote(offset, length);
    _noteList.add(note);
    note.addNoteListener(this);
    var be = BeatEvent(this, note, BeatEventType.noteCreated, Optional.empty());
    for (BeatListener l in _listenerList.getListeners<BeatListener>()) {
      l.beatUpdate(be);
    }
    return note;
  }

  Note createNote(int offset, double length) {
    return DefaultNote(this, offset, length);
  }

  @override
  Note getNoteAt(int index) {
    return _noteList.elementAt(index);
  }

  @override
  int get index => _index;

  @override
  Measure get measure => _measure;

  @override
  int get noteCount => _noteList.length;

  @override
  void removeBeatListener(BeatListener listener) {
    _listenerList.remove(listener);
  }

  @override
  void restoreNote(Note note) {
    note.addNoteListener(this);
    _noteList.add(note);
    var be = BeatEvent(this, note, BeatEventType.noteCreated, Optional.empty());
    for (BeatListener l in _listenerList.getListeners<BeatListener>()) {
      l.beatUpdate(be);
    }
  }

  @override
  void noteChange(NoteEvent e) {
    if (e.type == NoteEventType.removed) {
      e.source.removeNoteListener(this);
      _noteList.remove(e.source);
    }
    var be = BeatEvent(
        this, e.source, BeatEventType.propagationNoteEvents, Optional.of(e));
    for (BeatListener l in _listenerList.getListeners<BeatListener>()) {
      l.beatUpdate(be);
    }
  }
}
