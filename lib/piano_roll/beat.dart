import './beat_listener.dart';
import './measure.dart';
import './note.dart';

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
