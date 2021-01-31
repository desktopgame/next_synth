import 'dart:async';

import 'package:next_synth_midi/next_synth_midi.dart';
import 'package:optional/optional.dart';

class DeviceConnection {
  int deviceIndex;
  int inputPort;
  int outputPort;
  String name;

  DeviceConnection(
      this.deviceIndex, this.inputPort, this.outputPort, this.name);
}

class MidiHelper {
  static MidiHelper _instance;
  static MidiHelper get instance {
    if (_instance == null) {
      _instance = MidiHelper._internal();
    }
    return _instance;
  }

  List<DeviceConnection> _connections;
  MidiHelper._internal() {
    this._connections = List<DeviceConnection>();
  }

  Future<void> openPort(int deviceIndex, int inputPort, int outputPort) async {
    if (_connections
            .where((element) => element.deviceIndex == deviceIndex)
            .length >
        0) {
      // 既に一度開いているので無視
      return;
    }
    var name = await NextSynthMidi.getDeviceName(deviceIndex);
    _connections
        .add(DeviceConnection(deviceIndex, inputPort, outputPort, name));
    return await NextSynthMidi.openPort(deviceIndex, inputPort, outputPort);
  }

  List<DeviceConnection> getConnections() {
    return List()..addAll(_connections);
  }

  Optional<DeviceConnection> getConnection(int deviceIndex) {
    var conns = _connections
        .where((element) => element.deviceIndex == deviceIndex)
        .toList();
    if (conns.length == 0) {
      return Optional.empty();
    }
    return Optional.of(conns[0]);
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

  List<int> get devices {
    return _connections.map((e) => e.deviceIndex).toList();
  }

  bool isConnected(int deviceIndex) {
    return _connections
            .where((element) => element.deviceIndex == deviceIndex)
            .length >
        0;
  }

  Future<void> closeAll() async {
    var tmp = new List<DeviceConnection>()..addAll(_connections);
    for (var i in tmp) {
      await closePort(i.deviceIndex, i.inputPort, i.outputPort);
    }
    _connections.clear();
  }
}
