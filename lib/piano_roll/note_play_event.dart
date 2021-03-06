import 'package:next_synth/piano_roll/note.dart';
import 'package:next_synth/piano_roll/note_play_event_type.dart';
import 'package:next_synth/piano_roll/piano_roll_sequencer.dart';

class NotePlayEvent {
  final PianoRollSequencer source;
  final int trackIndex;
  final Note note;
  final NotePlayEventType type;

  NotePlayEvent(this.source, this.trackIndex, this.note, this.type);
}
