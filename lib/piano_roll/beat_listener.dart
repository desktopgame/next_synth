import './beat_event.dart';
import '../event/event_listener.dart';

abstract class BeatListener implements EventListener {
  void beatUpdate(BeatEvent e);
}
