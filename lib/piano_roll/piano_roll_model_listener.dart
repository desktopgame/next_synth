import './piano_roll_model_event.dart';
import '../event/event_listener.dart';

abstract class PianoRollModelListener implements EventListener {
  void pianoRollModelUpdate(PianoRollModelEvent e);
}
