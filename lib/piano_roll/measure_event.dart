import './beat_event.dart';
import './measure.dart';
import './measure_event_type.dart';
import 'package:optional/optional.dart';

class MeasureEvent {
  Measure _source;
  MeasureEventType _type;
  Optional<BeatEvent> _innerEvent;

  MeasureEvent(this._source, this._type, this._innerEvent);

  Measure get source => _source;
  MeasureEventType get type => _type;
  Optional<BeatEvent> get innerEvent => _innerEvent;
}
