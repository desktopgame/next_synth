class UpdateRate {
  final double timebase;
  final double bpm;
  final double tick;
  final double secPerBeat;

  UpdateRate(this.timebase, this.bpm, this.tick, this.secPerBeat);

  static UpdateRate bpmToUpdateRate(double timebase, double bpm) {
    double tick = 60.0 / bpm / timebase;
    double secPerBeat = tick * timebase;
    return new UpdateRate(timebase, bpm, tick, secPerBeat);
  }

  int computeTimerDelay(int beatWidth) {
    return ((secPerBeat * 1000.0) / beatWidth.toDouble()).round();
  }

  int computeDistancePerSec(int beatWidth) {
    return 1000 ~/ computeTimerDelay(beatWidth);
  }
}
