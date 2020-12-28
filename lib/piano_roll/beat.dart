import './beat_listener.dart';
import './note.dart';
import './measure.dart';

abstract class Beat {
  void addBeatListener(BeatListener listener);
  void removeBeatListener(BeatListener listener);
  Note generateNote(int offset, double length);
  void restoreNote(Note note);
  Note getNoteAt(int index);
  int get noteCount;
  int get index;
  Measure get measure;
}
