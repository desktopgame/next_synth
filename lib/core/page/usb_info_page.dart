import 'dart:async';

import 'package:flutter/material.dart';
import 'package:next_synth_midi/next_synth_midi.dart';

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
        children: [Text("認識されているMIDI機器"), _buildListView(context)],
      )),
    );
  }
}
