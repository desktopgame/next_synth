import './key_event.dart';
import '../event/event_listener.dart';

abstract class KeyListener implements EventListener {
  void keyUpdate(KeyEvent e);
}
