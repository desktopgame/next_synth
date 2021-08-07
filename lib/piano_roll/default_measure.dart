import 'package:optional/optional.dart';

import './beat.dart';
import './beat_event.dart';
import './beat_listener.dart';
import './default_beat.dart';
import './key.dart';
import './measure.dart';
import './measure_event.dart';
import './measure_event_type.dart';
import './measure_listener.dart';
import '../event/event_listener_list.dart';

class DefaultMeasure implements Measure, BeatListener {
  Key _key;
  int _index;
  int _beatCount;
  List<Beat> _beatList;
  EventListenerList _listenerList;

  DefaultMeasure(Key key, int index, int beatCount) {
    this._key = key;
    this._index = index;
    this._beatCount = beatCount;
    this._beatList = [];
    this._listenerList = EventListenerList();
    for (int i = 0; i < beatCount; i++) {
      _addBeat(i);
    }
  }

  void _addBeat(int index) {
    var b = createBeat(index);
    _beatList.add(b);
    b.addBeatListener(this);

    var me = MeasureEvent(this, MeasureEventType.beatCreated, Optional.empty());
    for (MeasureListener l in _listenerList.getListeners<MeasureListener>()) {
      l.measureUpdate(me);
    }
  }

  Beat createBeat(int index) {
    return DefaultBeat(this, index);
  }

  @override
  void addMeasureListener(MeasureListener listener) {
    _listenerList.add(listener);
  }

  @override
  int get beatCount => this._beatCount;

  @override
  Beat getBeatAt(int index) {
    return this._beatList.elementAt(index);
  }

  @override
  int get index => this._index;

  @override
  Key get key => this._key;

  @override
  void removeMeasureListener(MeasureListener listener) {
    this._listenerList.remove(listener);
  }

  @override
  void resizeBeatCount(int beatCount) {
    if (beatCount == this._beatCount) {
      return;
    }
    if (beatCount > this._beatCount) {
      int start = _beatList.length;
      while (this._beatList.length < beatCount) {
        _addBeat(start);
        start++;
      }
    } else {
      while (this._beatList.length > beatCount) {
        this._beatList.remove(_beatList.length - 1);
        var me =
            MeasureEvent(this, MeasureEventType.beatRemoved, Optional.empty());
        for (MeasureListener l
            in this._listenerList.getListeners<MeasureListener>()) {
          l.measureUpdate(me);
        }
      }
    }
    this._beatCount = beatCount;
  }

  @override
  void beatUpdate(BeatEvent e) {
    var me = MeasureEvent(
        this, MeasureEventType.propagationBeatEvents, Optional.of(e));
    for (MeasureListener l in _listenerList.getListeners<MeasureListener>()) {
      l.measureUpdate(me);
    }
  }
}
