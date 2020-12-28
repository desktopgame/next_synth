import './track.dart';

abstract class TrackListModel {
  Track createTrack();

  Track removeTrack(int index);

  Track getTrackAt(int index);

  int get size;
}
