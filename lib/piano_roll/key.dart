import './key_listener.dart';
import './measure.dart';
import './piano_roll_model.dart';

abstract class Key {
  void addKeyListener(KeyListener listener);
  void removeKeyListener(KeyListener listener);
  void resizeMeasureCount(int measureCount);
  void resizeBeatCount(int beatCount);
  Measure getMeasureAt(int index);
  int get measureCount;
  int get index;
  PianoRollModel get model;
}
