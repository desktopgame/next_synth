import 'package:next_synth/piano_roll/piano_roll_model.dart';

class Track {
  String name;
  bool isMute;
  int deviceIndex;
  int channel;
  PianoRollModel model;

  Track(this.name);
}
