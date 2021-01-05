import './measure_event.dart';
import '../event/event_listener.dart';

abstract class MeasureListener implements EventListener {
  void measureUpdate(MeasureEvent e);
}
