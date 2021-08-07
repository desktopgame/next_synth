import './event_listener.dart';

class EventListenerList {
  List<EventListener> _listeners;

  EventListenerList() {
    this._listeners = [];
  }

  void add(EventListener listener) {
    this._listeners.add(listener);
  }

  void remove(EventListener listener) {
    this._listeners.remove(listener);
  }

  void removeAt(int i) {
    this._listeners.removeAt(i);
  }

  List<T> getListeners<T>() {
    var ret = [];
    for (EventListener l in this._listeners) {
      if (l is T) {
        ret.add(l as T);
      }
    }
    return ret;
  }
}
