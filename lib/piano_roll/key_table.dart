import './key_color.dart';

class KeyTable {
  static final basic = KeyTable([
    KeyColor.white,
    KeyColor.black,
    KeyColor.white,
    KeyColor.black,
    KeyColor.white,
    KeyColor.white,
    KeyColor.black,
    KeyColor.white,
    KeyColor.black,
    KeyColor.white,
    KeyColor.black,
    KeyColor.white,
  ]);
  static final names = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B",
  ];
  List<KeyColor> _data;

  KeyTable(this._data);

  KeyColor getColorAt(int index) {
    int a = index % _data.length;
    return _data.elementAt(a);
  }

  List<KeyColor> get colors => [..._data];
  int get length => _data.length;
}
