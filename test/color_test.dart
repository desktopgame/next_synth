import 'package:next_synth/piano_roll/key_table.dart';
import 'package:test/test.dart';
import 'dart:async';

void main() {
  test('Color', () {
    for (int i = 0; i < 30; i++) {
      print(KeyTable.basic.getColorAt(i));
    }
  });
}
