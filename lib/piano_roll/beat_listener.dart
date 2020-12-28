import '../event/event_listener.dart';
import './beat_event.dart';

abstract class BeatListener implements EventListener {
  void beatUpdate(BeatEvent e);
}
