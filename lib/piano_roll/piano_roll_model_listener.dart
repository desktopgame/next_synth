import '../event/event_listener.dart';
import './piano_roll_model_event.dart';

abstract class PianoRollModelListener implements EventListener {
  void pianoRollModelUpdate(PianoRollModelEvent e);
}
