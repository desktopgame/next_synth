import 'dart:async';

import 'package:rxdart/rxdart.dart';

import './piano_roll_ui.dart';
import './update_rate.dart';

class PianoRollSequencer {
  int position;
  int step;
  UpdateRate updateRate;
  void Function() _onTick;
  PianoRollUI _ui;
  Timer _timer;
  bool _isPlaying;
  BehaviorSubject<bool> _playingController;

  Stream<bool> get playingStream => _playingController.stream;

  PianoRollSequencer(this._ui, {void Function() onTick})
      : this._onTick = onTick {
    this.position = 0;
    this.step = 1;
    this.updateRate = UpdateRate.bpmToUpdateRate(480, 120);
    this._isPlaying = false;
    this._playingController = BehaviorSubject();
  }

  bool get isPlaying => _isPlaying;

  void start() {
    int bw = _ui.style.beatWidth;
    int delay = updateRate.computeTimerDelay(bw);
    int stemp = delay;
    this.step = 1;
    while (delay < 32) {
      delay += stemp;
      this.step++;
    }
    print('delay $delay, step $step');
    this._isPlaying = true;
    _playingController.sink.add(true);
    this._timer = Timer.periodic(Duration(milliseconds: delay), _onTime);
    //timer.setInitialDelay(0);
    //timer.setDelay(delay);
  }

  void pause() {
    this._isPlaying = false;
    _playingController.sink.add(false);
    _timer.cancel();
    if (this._onTick != null) {
      this._onTick();
    }
  }

  void stop() {
    this.position = 0;
    if (_isPlaying) {
      this._isPlaying = false;
      _playingController.sink.add(false);
      _timer.cancel();
    }
    if (this._onTick != null) {
      this._onTick();
    }
  }

  void _onTime(Timer timer) {
    for (int i = 0; i < step; i++) {
      _doStep();
    }
    if (this._onTick != null) {
      this._onTick();
    }
  }

  void _doStep() {
    this.position++;
  }
}
