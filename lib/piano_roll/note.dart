import './note_listener.dart';
import './beat.dart';

abstract class Note {
  void addNoteListener(NoteListener listener);
  void removeNoteListener(NoteListener listener);
  void play();
  void removeFromBeat();
  set selected(bool b);
  bool get selected;
  set offset(int i);
  int get offset;
  set length(double d);
  double get length;
  set trigger(bool b);
  bool get trigger;
  Beat get beat;
}
