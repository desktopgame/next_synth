import './track.dart';
import 'package:flutter/material.dart' show Color;

abstract class TrackListModel {
  Track createTrack();

  Track removeTrack(int index);

  Track getTrackAt(int index);

  Color getTrackSkinColor(int index);

  int get size;
}
