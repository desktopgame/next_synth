import 'dart:async';

import 'package:next_synth_midi/next_synth_midi.dart';

class _DeviceConnection {
  int deviceIndex;
  int inputPort;
  int outputPort;

  _DeviceConnection(this.deviceIndex, this.inputPort, this.outputPort);
}

class MidiHelper {
  static MidiHelper _instance;
  static MidiHelper get instance {
    if (_instance == null) {
      _instance = MidiHelper._internal();
    }
    return _instance;
  }

  List<_DeviceConnection> _connections;
  MidiHelper._internal() {
    this._connections = List<_DeviceConnection>();
  }

  Future<void> openPort(int deviceIndex, int inputPort, int outputPort) async {
    if (_connections
            .where((element) => element.deviceIndex == deviceIndex)
            .length >
        0) {
      // 既に一度開いているので無視
      return;
    }
    _connections.add(_DeviceConnection(deviceIndex, inputPort, outputPort));
    return await NextSynthMidi.openPort(deviceIndex, inputPort, outputPort);
  }

  Future<int> closePort(int deviceIndex, int inputPort, int outputPort) async {
    if (_connections
            .where((element) => element.deviceIndex == deviceIndex)
            .length ==
        0) {
      // まだ開いていないので無視
      return 0;
    }
    _connections.removeWhere((element) => element.deviceIndex == deviceIndex);
    return await NextSynthMidi.closePort(deviceIndex, inputPort, outputPort);
  }

  bool isConnected(int deviceIndex) {
    return _connections
            .where((element) => element.deviceIndex == deviceIndex)
            .length >
        0;
  }

  Future<void> closeAll() async {
    var tmp = new List<_DeviceConnection>()..addAll(_connections);
    for (var i in tmp) {
      await closePort(i.deviceIndex, i.inputPort, i.outputPort);
    }
    _connections.clear();
  }
}
