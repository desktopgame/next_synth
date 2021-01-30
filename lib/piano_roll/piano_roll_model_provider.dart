import './piano_roll_model.dart';

abstract class PianoRollModelProvider {
  PianoRollModel getModelAt(int i);
  int get count;
}
