import 'package:next_synth/event/event_listener.dart';
import 'package:next_synth/piano_roll/note_play_event.dart';

abstract class NotePlayListener implements EventListener {
  void notePlay(NotePlayEvent e);
}
