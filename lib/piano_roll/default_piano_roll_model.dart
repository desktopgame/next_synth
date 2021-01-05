import 'package:optional/optional.dart';

import './default_key.dart';
import './key.dart';
import './key_event.dart';
import './key_listener.dart';
import './piano_roll_model.dart';
import './piano_roll_model_event.dart';
import './piano_roll_model_event_type.dart';
import './piano_roll_model_listener.dart';
import './undoable_edit_listener.dart';
import '../event/event_listener_list.dart';

class DefaultPianoRollModel implements PianoRollModel, KeyListener {
  List<Key> _keyList;
  EventListenerList _listenerList;
  int _keyCount;
  int _measureCount;
  int _beatCount;
  int undoableEditStack;

  DefaultPianoRollModel(int keyCount, int measureCount, int beatCount) {
    this._keyList = List<Key>();
    this._listenerList = EventListenerList();
    this._keyCount = keyCount;
    this._measureCount = measureCount;
    this._beatCount = beatCount;
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
    // postUndoableEdit(ee);
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
    // TODO: implement addUndoableEditListener
  }

  @override
  void beginApplyUndoableEdit() {
    // TODO: implement beginApplyUndoableEdit
  }

  @override
  void beginCompoundUndoableEdit() {
    // TODO: implement beginCompoundUndoableEdit
  }

  @override
  void endApplyUndoableEdit() {
    // TODO: implement endApplyUndoableEdit
  }

  @override
  void endCompoundUndoableEdit() {
    // TODO: implement endCompoundUndoableEdit
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
    // TODO: implement removeUndoableEditListener
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
        // postUndoableEdit(ee);
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
    // postUndoableEdit(ee);
    for (PianoRollModelListener l
        in this._listenerList.getListeners<PianoRollModelListener>()) {
      l.pianoRollModelUpdate(pme);
    }
  }
}
