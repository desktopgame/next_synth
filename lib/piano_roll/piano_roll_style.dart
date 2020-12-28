import 'package:next_synth/event/notification_listener.dart' as P;
import 'package:flutter/material.dart';
import '../event/notification_listener.dart';
import '../event/notification_event.dart';
import '../event/event_listener_list.dart';

class PianoRollStyle {
  EventListenerList _listenerList;
  int beatWidth;
  int beatHeight;
  int beatSplitCount;
  Paint blackKeyPaint = Paint()..color = Colors.black87;
  Paint whiteKeyPaint = Paint()..color = Colors.white;
  Paint selectedNotePaint = Paint()..color = Colors.cyan;
  Paint unselectedNotePaint = Paint()..color = Colors.pink;
  Paint noteFramePaint1 = Paint()
    ..color = Colors.black54
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  Paint noteFramePaint2 = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  Paint verticalLinePaint = Paint()..color = Color.fromARGB(255, 105, 112, 112);
  Paint verticalHighlightLinePaint = Paint()..color = Colors.yellow;
  Offset scrollOffset = Offset(0, 0);
  PianoRollStyle() {
    this._listenerList = EventListenerList();
    this.beatWidth = 96;
    this.beatHeight = 16;
    this.beatSplitCount = 4;
  }

  void addNotificationListener(
      P.NotificationListener<PianoRollStyle> listener) {
    _listenerList.add(listener);
  }

  void removeNotificationListener(
      P.NotificationListener<PianoRollStyle> listener) {
    _listenerList.remove(listener);
  }

  void refresh() {
    _fire();
  }

  void _fire() {
    var evt = NotificationEvent<PianoRollStyle>(this);
    for (P.NotificationListener<PianoRollStyle> l in _listenerList
        .getListeners<P.NotificationListener<PianoRollStyle>>()) {
      l.notify(evt);
    }
  }
}
