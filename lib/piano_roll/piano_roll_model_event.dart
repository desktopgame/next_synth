import 'package:next_synth/piano_roll/beat_event.dart';
import 'package:next_synth/piano_roll/measure_event.dart';
import 'package:optional/optional.dart';

import './key_event.dart';
import './piano_roll_model.dart';
import './piano_roll_model_event_type.dart';

class PianoRollModelEvent {
  PianoRollModel _source;
  PianoRollModelEventType _type;
  Optional<KeyEvent> _innerEvent;

  PianoRollModelEvent(this._source, this._type, this._innerEvent);

  PianoRollModel get source => _source;
  PianoRollModelEventType get type => _type;
  Optional<KeyEvent> get innerEvent => _innerEvent;
  Optional<MeasureEvent> get measureEvent =>
      _innerEvent.isPresent ? _innerEvent.value.innerEvent : Optional.empty();
  Optional<BeatEvent> get beatEvent =>
      measureEvent.isPresent ? measureEvent.value.innerEvent : Optional.empty();
}
