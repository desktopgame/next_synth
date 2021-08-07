import 'package:optional/optional.dart';

import './default_measure.dart';
import './key.dart';
import './key_event.dart';
import './key_event_type.dart';
import './key_listener.dart';
import './measure.dart';
import './measure_event.dart';
import './measure_listener.dart';
import './piano_roll_model.dart';
import '../event/event_listener_list.dart';

class DefaultKey implements Key, MeasureListener {
  PianoRollModel _model;
  List<Measure> _measureList;
  EventListenerList _listenerList;
  int _height;
  int _measureCount;
  int _beatCount;

  DefaultKey(
      PianoRollModel model, int measureCount, int beatCount, int height) {
    this._model = model;
    this._measureList = [];
    this._height = height;
    this._measureCount = measureCount;
    this._beatCount = beatCount;
    this._listenerList = EventListenerList();
    for (int i = 0; i < measureCount; i++) {
      _addMeasure(i);
    }
  }

  void _addMeasure(int index) {
    var measure = createMeasure(index, this._beatCount);
    _measureList.add(measure);
    measure.addMeasureListener(this);
    var ke = KeyEvent(this, KeyEventType.measureCreated, Optional.empty());
    for (KeyListener l in this._listenerList.getListeners<KeyListener>()) {
      l.keyUpdate(ke);
    }
  }

  Measure createMeasure(int index, int beatCount) {
    return DefaultMeasure(this, index, beatCount);
  }

  @override
  void addKeyListener(KeyListener listener) {
    this._listenerList.add(listener);
  }

  @override
  Measure getMeasureAt(int index) {
    return this._measureList.elementAt(index);
  }

  @override
  int get index => this._height;

  @override
  int get measureCount => this._measureList.length;

  @override
  PianoRollModel get model => this._model;

  @override
  void removeKeyListener(KeyListener listener) {
    this._listenerList.remove(listener);
  }

  @override
  void resizeBeatCount(int beatCount) {
    for (Measure m in _measureList) {
      m.resizeBeatCount(beatCount);
    }
  }

  @override
  void resizeMeasureCount(int measureCount) {
    if (measureCount == this._measureCount) {
      return;
    }
    if (measureCount > this._measureCount) {
      int start = _measureList.length;
      while (this._measureList.length < measureCount) {
        _addMeasure(start);
        start++;
      }
    } else {
      while (this._measureList.length > measureCount) {
        this._measureList.remove(_measureList.length - 1);
        var ke = KeyEvent(this, KeyEventType.measureRemoved, Optional.empty());
        for (KeyListener l in this._listenerList.getListeners<KeyListener>()) {
          l.keyUpdate(ke);
        }
      }
    }
    this._measureCount = measureCount;
  }

  @override
  void measureUpdate(MeasureEvent e) {
    var ke =
        KeyEvent(this, KeyEventType.propagationMeasureEvents, Optional.of(e));
    for (KeyListener l in this._listenerList.getListeners<KeyListener>()) {
      l.keyUpdate(ke);
    }
  }
}
