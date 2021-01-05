import './note_event.dart';
import '../event/event_listener.dart';

abstract class NoteListener implements EventListener {
  void noteChange(NoteEvent e);
}
