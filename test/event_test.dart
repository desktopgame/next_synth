import 'package:next_synth/event/event_listener_list.dart';
import 'package:next_synth/event/event_listener.dart';
import 'package:test/test.dart';
import 'dart:async';

abstract class SimpleListener implements EventListener {
  void onNotify(String str);
}

class SimpleListenerImpl implements SimpleListener {
  bool called;
  void onNotify(String str) {
    print(str);
    this.called = true;
  }
}

void main() {
  test('StreamController', () {
    var listenerList = EventListenerList();
    listenerList.add(SimpleListenerImpl());
    for (SimpleListener l in listenerList.getListeners<SimpleListener>()) {
      l.onNotify("fire");
    }
    for (SimpleListener l in listenerList.getListeners<SimpleListener>()) {
      expect((l as SimpleListenerImpl).called, true);
    }
  });
}
