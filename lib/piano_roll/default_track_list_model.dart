import 'package:next_synth/piano_roll/track.dart';

import './track_list_model.dart';

class DefaultTrackListModel implements TrackListModel {
  List<Track> _tracks;

  DefaultTrackListModel() {
    this._tracks = List<Track>();
  }

  @override
  Track createTrack() {
    if (_tracks.isEmpty) {
      var track = Track("Track.0");
      _tracks.add(track);
      return track;
    }
    int n = _tracks.length;
    String name = 'Track.$n';
    while (_indexOf(name) >= 0) {
      name = 'Track.$n';
      n++;
    }
    var track = Track(name);
    _tracks.add(track);
    return track;
  }

  int _indexOf(String name) {
    int n = 0;
    for (Track t in _tracks) {
      if (t.name == name) {
        return n;
      }
      n++;
    }
    return -1;
  }

  @override
  Track getTrackAt(int index) {
    return _tracks.elementAt(index);
  }

  @override
  Track removeTrack(int index) {
    var track = _tracks.elementAt(index);
    _tracks.removeAt(index);
    return track;
  }

  @override
  int get size => _tracks.length;
}
