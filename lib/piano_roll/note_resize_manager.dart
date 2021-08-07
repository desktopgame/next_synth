import 'dart:math';

import './note.dart';
import './note_resize_event.dart';
import './note_resize_listener.dart';
import '../event/event_listener_list.dart';

enum NoteResizeType { resize, move }

class NoteResizeManager {
  NoteResizeType _type;
  List<Note> _notes;
  List<int> _offsetTable;
  List<double> _lengthTable;
  int _baseX;
  int _currentX;
  bool _hasFocus;
  EventListenerList _listenerList;
  Note _baseNote;

  NoteResizeManager() {
    this._type = NoteResizeType.move;
    this._notes = [];
    this._offsetTable = [];
    this._lengthTable = [];
    this._baseX = 0;
    this._currentX = 0;
    this._hasFocus = false;
    this._listenerList = EventListenerList();
    this._baseNote = null;
  }

  void addNoteResizeListener(NoteResizeListener listener) {
    _listenerList.add(listener);
  }

  void removeNoteResizeListener(NoteResizeListener listener) {
    _listenerList.remove(listener);
  }

  void touch(Note note) {
    this._notes.add(note);
    this._baseNote = note;
  }

  void touchAll(List<Note> notes) {
    for (var note in notes) {
      touch(note);
    }
  }

  void clear() {
    this._notes.clear();
    this._baseNote = null;
  }

  void start(NoteResizeType type, int x) {
    this._notes = this._notes.toSet().toList();
    this._type = type;
    this._baseX = x;
    this._hasFocus = true;
    this._offsetTable = _notes.map((e) => e.offset).toList();
    this._lengthTable = _notes.map((e) => e.length).toList();
    var e = NoteResizeEvent(this);
    for (var listener in _listenerList.getListeners<NoteResizeListener>()) {
      listener.resizeStart(e);
    }
  }

  void resize(int x, int beatWidth) {
    this._currentX = x;
    int diffX = this._currentX - _baseX;
    double addX = (diffX.toDouble() / beatWidth.toDouble());
    for (int i = 0; i < _notes.length; i++) {
      var n = _notes[i];
      if (this._type == NoteResizeType.resize) {
        double newLength = max(0.1, _lengthTable[i] + addX);
        n.length = newLength;
      } else {
        if (_lengthTable[i] - addX > 0) {
          int newOffset = _offsetTable[i] + diffX;
          n.offset = newOffset;
          n.length = max(0.1, _lengthTable[i] - addX);
        }
      }
    }
  }

  void stop() {
    this._notes.clear();
    this._baseX = 0;
    this._currentX = 0;
    this._hasFocus = false;
    this._baseNote = null;
    var e = NoteResizeEvent(this);
    for (var listener in _listenerList.getListeners<NoteResizeListener>()) {
      listener.resizeEnd(e);
    }
  }

  Note get baseNote => _baseNote;
  List<Note> get targets => _notes;
  int get currentX => _currentX;
  int get baseX => _baseX;
  NoteResizeType get type => _type;
  bool get hasFocus => _hasFocus;
}
