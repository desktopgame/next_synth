import 'package:optional/optional.dart';

import './beat.dart';
import './beat_event_type.dart';
import './note.dart';
import './note_event.dart';

class BeatEvent {
  Beat _source;
  Note _note;
  BeatEventType _beatEventType;
  Optional<NoteEvent> _noteEvent;

  BeatEvent(this._source, this._note, this._beatEventType, this._noteEvent);

  Beat get source => _source;
  Note get note => _note;
  BeatEventType get beatEventType => _beatEventType;
  Optional<NoteEvent> get noteEvent => _noteEvent;
}
