import './undoable_edit_event.dart';
import '../event/event_listener.dart';

abstract class UndoableEditListener implements EventListener {
  void undoableEdit(UndoableEditEvent e);
}
