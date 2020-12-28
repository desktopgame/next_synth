import 'package:optional/optional.dart';

import './note.dart';
import './note_event_type.dart';

class NoteEvent {
  Note _source;
  NoteEventType _type;
  Optional<Object> _oldValue;
  Optional<Object> _newValue;

  NoteEvent(this._source, this._type, this._oldValue, this._newValue);

  Note get source => _source;
  NoteEventType get type => _type;
  Optional<Object> get oldValue => _oldValue;
  Optional<Object> get newValue => _newValue;
}
