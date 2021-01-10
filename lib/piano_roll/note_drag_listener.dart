import './note_drag_event.dart';
import '../event/event_listener.dart';

abstract class NoteDragListener implements EventListener {
  void dragStart(NoteDragEvent e);
  void dragEnd(NoteDragEvent e);
}
