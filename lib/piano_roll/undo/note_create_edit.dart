import 'package:next_synth/undo/undoable_edit.dart';

import '../beat.dart';
import '../note.dart';
import '../piano_roll_model.dart';

class NoteCreateEdit implements UndoableEdit {
  PianoRollModel model;
  Beat beat;
  Note note;

  NoteCreateEdit(this.model, this.beat, this.note);

  @override
  void redo() {
    try {
      model.beginApplyUndoableEdit();
      beat.restoreNote(note);
    } finally {
      model.endApplyUndoableEdit();
    }
  }

  @override
  void undo() {
    try {
      model.beginApplyUndoableEdit();
      note.removeFromBeat();
    } finally {
      model.endApplyUndoableEdit();
    }
  }
}
