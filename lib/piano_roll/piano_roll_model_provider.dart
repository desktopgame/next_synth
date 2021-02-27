import './piano_roll_model.dart';
import 'package:flutter/material.dart' show Color;

abstract class PianoRollModelProvider {
  PianoRollModel getModelAt(int i);
  Color getTrackSkinColor(int index);

  int get count;
}
