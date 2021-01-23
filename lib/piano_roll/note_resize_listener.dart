import './note_resize_event.dart';
import '../event/event_listener.dart';

abstract class NoteResizeListener implements EventListener {
  void resizeStart(NoteResizeEvent e);
  void resizeEnd(NoteResizeEvent e);
}
