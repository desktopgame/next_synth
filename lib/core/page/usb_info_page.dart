import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_synth_midi/next_synth_midi.dart';

import '../system/midi_helper.dart';

class USBInfoPage extends StatelessWidget {
  Future<int> getDeviceCount() async {
    return await NextSynthMidi.deviceCount;
  }

  Widget _buildListCellInputs(BuildContext context, int index) {
    return FutureBuilder(
        future: NextSynthMidi.getInputPortCount(index),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Text("入力ポート数: ${snapshot.data as int}");
          }
        });
  }

  Widget _buildListCellOutputs(BuildContext context, int index) {
    return FutureBuilder(
        future: NextSynthMidi.getOutputPortCount(index),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Text("出力ポート数: ${snapshot.data as int}");
          }
        });
  }

  Widget _buildListSwitch(BuildContext context, int index) {
    var streamCon = StreamController<int>();
    return FutureBuilder(builder: (context, snapshot) {
      return SizedBox(
          width: 400,
          height: 60,
          child: StreamBuilder(
            stream: streamCon.stream,
            builder: (context, snapshot) {
              var connected = MidiHelper.instance.isConnected(index);
              var label = "接続状態: " + (connected ? "O" : "X") + "";
              return SwitchListTile(
                value: connected,
                activeColor: Colors.blue,
                activeTrackColor: Colors.cyan,
                inactiveThumbColor: Colors.blue,
                inactiveTrackColor: Colors.grey,
                title: Text(label),
                onChanged: (e) async {
                  try {
                    if (e) {
                      await MidiHelper.instance.openPort(index, 0, -1);
                    } else {
                      await MidiHelper.instance.closePort(index, 0, -1);
                    }
                    streamCon.sink.add(0);
                  } catch (ex) {
                    Fluttertoast.showToast(
                        msg: "エラーが発生しました。",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              );
            },
          ));
    });
  }

  Widget _buildListCell(BuildContext context, int index) {
    return FutureBuilder(
      future: NextSynthMidi.getDeviceName(index),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return Row(children: [
            Text(snapshot.data),
            Spacer(),
            _buildListSwitch(context, index),
            _buildListCellInputs(context, index),
            _buildListCellOutputs(context, index),
          ]);
        }
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return FutureBuilder(
        future: NextSynthMidi.deviceCount,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data as int <= 0) {
            return Text("MIDI機器が接続されていません。");
          }
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data as int,
              itemBuilder: (context, i) {
                return _buildListCell(context, i);
              });
          ;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NextSynth'),
      ),
      body: Center(
          child: Column(
        children: [
          Text("認識されているMIDI機器"),
          _buildListView(context),
          ElevatedButton(
            child: Text("発音テスト"),
            onPressed: () async {
              for (int devI in MidiHelper.instance.devices) {
                NextSynthMidi.send(
                    devI, 0, Uint8List.fromList([0x90, 60, 127]), 0, 3);
              }
              await Future.delayed(new Duration(seconds: 3));
              for (int devI in MidiHelper.instance.devices) {
                NextSynthMidi.send(
                    devI, 0, Uint8List.fromList([0x80, 60, 0]), 0, 3);
              }
            },
          )
        ],
      )),
    );
  }
}
