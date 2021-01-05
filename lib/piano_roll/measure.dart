import './beat.dart';
import './key.dart';
import './measure_listener.dart';

abstract class Measure {
  void addMeasureListener(MeasureListener listener);
  void removeMeasureListener(MeasureListener listener);
  void resizeBeatCount(int beatCount);
  Beat getBeatAt(int index);
  int get beatCount;
  int get index;
  Key get key;
}
