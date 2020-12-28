import './key_event_type.dart';
import './measure_event.dart';
import 'package:optional/optional.dart';

import './key.dart';

class KeyEvent {
  Key _source;
  KeyEventType _type;
  Optional<MeasureEvent> _innerEvent;

  KeyEvent(this._source, this._type, this._innerEvent);

  Key get source => _source;
  KeyEventType get type => _type;
  Optional<MeasureEvent> get innerEvent => _innerEvent;
}
