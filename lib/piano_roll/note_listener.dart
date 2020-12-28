import '../event/event_listener.dart';
import './note_event.dart';

abstract class NoteListener implements EventListener {
  void noteChange(NoteEvent e);
}
