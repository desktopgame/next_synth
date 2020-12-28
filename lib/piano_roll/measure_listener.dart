import '../event/event_listener.dart';
import './measure_event.dart';

abstract class MeasureListener implements EventListener {
  void measureUpdate(MeasureEvent e);
}
