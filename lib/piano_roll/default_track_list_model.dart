import 'package:flutter/material.dart' hide Stack;
import 'package:stack/stack.dart';
import 'package:next_synth/piano_roll/track.dart';
import 'dart:math';

import './track_list_model.dart';
import 'package:stack/stack.dart';

class DefaultTrackListModel implements TrackListModel {
  List<Track> _tracks;
  List<Color> _colorList;
  Stack<Color> _colorBuf;

  DefaultTrackListModel()
      : _tracks = [],
        _colorList = [],
        _colorBuf = Stack<Color>() {
    _colorBuf.push(Colors.red);
    _colorBuf.push(Colors.orange);
    _colorBuf.push(Colors.pink);
    _colorBuf.push(Colors.purple);
    _colorBuf.push(Colors.yellow);
    _colorBuf.push(Colors.lime);
    _colorBuf.push(Colors.amber);
    _colorBuf.push(Colors.blue);
    _colorBuf.push(Colors.cyan);
    _colorBuf.push(Colors.indigo);
    _colorBuf.push(Colors.teal);
    _colorBuf.push(Colors.green);
    _colorBuf.push(Colors.grey);
    _colorBuf.push(Colors.brown);
    _colorBuf.push(Colors.black);
  }

  @override
  Track createTrack() {
    _addColor();
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

  void _addColor() {
    if (!_colorBuf.isEmpty) {
      _colorList.add(_colorBuf.pop());
      return;
    }
    Random random = new Random();
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);
    if (_colorList.any((c) =>
        _nearEq(c.red, r) && _nearEq(c.green, g) && _nearEq(c.blue, b))) {
      _addColor();
    } else {
      _colorList.add(Color.fromARGB(255, r, g, b));
    }
  }

  void _removeColor(int i) {
    _colorBuf.push(_colorList[i]);
    _colorList.remove(i);
  }

  bool _nearEq(int a, int b) {
    int diff = a - b;
    if (diff < 0) diff = -diff;
    return diff < 10;
  }

  @override
  Track getTrackAt(int index) {
    return _tracks.elementAt(index);
  }

  @override
  Color getTrackSkinColor(int index) {
    return _colorList.elementAt(index);
  }

  @override
  Track removeTrack(int index) {
    _removeColor(index);
    var track = _tracks.elementAt(index);
    _tracks.removeAt(index);
    return track;
  }

  @override
  int get size => _tracks.length;
}
