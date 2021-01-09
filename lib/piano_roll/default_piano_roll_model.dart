import 'package:flutter/material.dart' hide Key;
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';
import 'package:next_synth/undo/undo_manager.dart';
import 'package:optional/optional.dart';

import './beat_event.dart';
import './beat_event_type.dart';
import './default_key.dart';
import './key.dart';
import './key_event.dart';
import './key_listener.dart';
import './note_event.dart';
import './note_event_type.dart';
import './piano_roll_model.dart';
import './piano_roll_model_event.dart';
import './piano_roll_model_event_type.dart';
import './piano_roll_model_listener.dart';
import '../event/event_listener_list.dart';
import '../undo/undo_manager.dart';
import '../undo/undoable_edit_listener.dart';
import 'undo/note_create_edit.dart';
import 'undo/note_length_edit.dart';
import 'undo/note_offset_edit.dart';
import 'undo/note_remove_edit.dart';
import 'undo/note_select_edit.dart';

class DefaultPianoRollModel implements PianoRollModel, KeyListener {
  List<Key> _keyList;
  EventListenerList _listenerList;
  int _keyCount;
  int _measureCount;
  int _beatCount;
  int _locked;
  UndoManager _undoManager;

  DefaultPianoRollModel(int keyCount, int measureCount, int beatCount) {
    this._keyList = List<Key>();
    this._listenerList = EventListenerList();
    this._keyCount = keyCount;
    this._measureCount = measureCount;
    this._beatCount = beatCount;
    this._locked = 0;
    this._undoManager = UndoManager();
    for (int i = 0; i < keyCount; i++) {
      _addKey(i);
    }
  }

  void _addKey(int height) {
    var k = createKey(this._measureCount, this._beatCount, height);
    _keyList.add(k);
    k.addKeyListener(this);
    var e = PianoRollModelEvent(
        this, PianoRollModelEventType.keyCreated, Optional.empty());
    _postUndoableEdit(e);
    for (PianoRollModelListener l
        in this._listenerList.getListeners<PianoRollModelListener>()) {
      l.pianoRollModelUpdate(e);
    }
  }

  Key createKey(int measureCount, int beatCount, int height) {
    return DefaultKey(this, measureCount, beatCount, height + 1);
  }

  @override
  void addPianoRollModelListener(PianoRollModelListener listener) {
    _listenerList.add(listener);
  }

  @override
  void addUndoableEditListener(UndoableEditListener listener) {
    _undoManager.addUndoableEditListener(listener);
  }

  @override
  void beginApplyUndoableEdit() {
    this._locked++;
  }

  @override
  void beginCompoundUndoableEdit() {
    _undoManager.beginCompoundEdit();
  }

  @override
  void endApplyUndoableEdit() {
    this._locked--;
  }

  @override
  void endCompoundUndoableEdit() {
    _undoManager.endCompoundEdit();
  }

  @override
  Key getKeyAt(int index) {
    return _keyList.elementAt(index);
  }

  @override
  int getKeyHeight(int keyIndex) {
    return _keyCount - keyIndex;
  }

  @override
  int get keyCount => _keyList.length;

  @override
  void removePianoRollModelListener(PianoRollModelListener listener) {
    _listenerList.remove(listener);
  }

  @override
  void removeUndoableEditListener(UndoableEditListener listener) {
    _undoManager.removeUndoableEditListener(listener);
  }

  @override
  void resizeBeatCount(int beatCount) {
    for (Key k in _keyList) {
      k.resizeBeatCount(beatCount);
    }
  }

  @override
  void resizeKeyCount(int keyCount) {
    if (keyCount == this._keyCount) {
      return;
    }
    if (keyCount > this._keyCount) {
      int start = _keyList.length;
      while (this._keyList.length < keyCount) {
        _addKey(start);
        start++;
      }
    } else {
      while (this._keyList.length > keyCount) {
        this._keyList.remove(_keyList.length - 1);
        var pme = PianoRollModelEvent(
            this, PianoRollModelEventType.keyRemoved, Optional.empty());
        _postUndoableEdit(pme);
        for (PianoRollModelListener l
            in this._listenerList.getListeners<PianoRollModelListener>()) {
          l.pianoRollModelUpdate(pme);
        }
      }
    }
    this._keyCount = keyCount;
  }

  @override
  void resizeMeasureCount(int measureCount) {
    for (Key k in _keyList) {
      k.resizeMeasureCount(measureCount);
    }
  }

  @override
  void keyUpdate(KeyEvent e) {
    var pme = PianoRollModelEvent(
        this, PianoRollModelEventType.propagationKeyEvents, Optional.of(e));
    _postUndoableEdit(pme);
    for (PianoRollModelListener l
        in this._listenerList.getListeners<PianoRollModelListener>()) {
      l.pianoRollModelUpdate(pme);
    }
  }

  Optional<BeatEvent> _unwrapBeatEvent(PianoRollModelEvent e) {
    var a = e.innerEvent;
    if (!a.isPresent) {
      return Optional.empty();
    }
    var b = a.value.innerEvent;
    if (!b.isPresent) {
      return Optional.empty();
    }
    return b.value.innerEvent;
  }

  Optional<NoteEvent> _unwrapNoteEvent(PianoRollModelEvent e) {
    var be = _unwrapBeatEvent(e);
    if (be.isPresent) {
      return be.value.innerEvent;
    }
    return Optional.empty();
  }

  void _postUndoableEdit(PianoRollModelEvent e) {
    if (_locked > 0) {
      return;
    }
    Optional<BeatEvent> beOpt = _unwrapBeatEvent(e);
    if (beOpt.isPresent) {
      BeatEvent be = beOpt.value;
      if (be.beatEventType == BeatEventType.noteCreated) {
        _undoManager.submit(NoteCreateEdit(this, be.source, be.note));
        return;
      }
    }
    Optional<NoteEvent> noOpt = _unwrapNoteEvent(e);
    if (noOpt.isPresent) {
      NoteEvent no = noOpt.value;
      Optional<Object> o = no.oldValue;
      Optional<Object> n = no.newValue;
      if (no.type == NoteEventType.removed) {
        _undoManager.submit(NoteRemoveEdit(this, no.source.beat, no.source));
      } else if (no.type == NoteEventType.offsetChange) {
        _undoManager.submit(NoteOffsetEdit(this, no.source, o.value as int));
      } else if (no.type == NoteEventType.lengthChange) {
        _undoManager.submit(NoteLengthEdit(this, no.source, o.value as double));
      } else if (no.type == NoteEventType.selectionChange) {
        _undoManager.submit(NoteSelectEdit(this, no.source));
      }
      return;
    }
  }

  @override
  bool get canRedo => _undoManager.canRedo;

  @override
  bool get canUndo => _undoManager.canUndo;

  @override
  void redo() {
    _undoManager.redo();
  }

  @override
  void undo() {
    _undoManager.undo();
  }

  @override
  void clear() {
    PianoRollUtilities.getAllNoteList(this).forEach((element) {
      element.removeFromBeat();
    });
    _undoManager.discardAllEdits();
  }

  @override
  PianoRollModel duplicate() {
    var ret = new DefaultPianoRollModel(keyCount, getKeyAt(0).measureCount,
        getKeyAt(0).getMeasureAt(0).beatCount);
    ret.merge(this);
    return ret;
  }

  @override
  bool merge(PianoRollModel model) {
    if (keyCount != model.keyCount) {
      return false;
    }
    int n = 0;
    var notes = PianoRollUtilities.getAllNoteList(model);
    for (int i = 0; i < model.keyCount; i++) {
      var dstKey = this.getKeyAt(i);
      var srcKey = model.getKeyAt(i);
      if (dstKey.measureCount != srcKey.measureCount) {
        return false;
      }
      for (int j = 0; j < dstKey.measureCount; j++) {
        var dstMeasure = dstKey.getMeasureAt(j);
        var srcMeasure = srcKey.getMeasureAt(j);
        if (dstMeasure.beatCount != srcMeasure.beatCount) {
          return false;
        }
        for (int k = 0; k < dstMeasure.beatCount; k++) {
          var dstBeat = dstMeasure.getBeatAt(k);
          var srcBeat = srcMeasure.getBeatAt(k);
          for (int L = 0; L < srcBeat.noteCount; L++) {
            var srcNote = srcBeat.getNoteAt(L);
            dstBeat.generateNote(srcNote.offset, srcNote.length);
            n++;
          }
        }
      }
    }
    _undoManager.discardAllEdits();
    return true;
  }
}
