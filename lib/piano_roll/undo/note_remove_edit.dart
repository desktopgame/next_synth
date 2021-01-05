import 'package:next_synth/undo/undoable_edit.dart';

import '../beat.dart';
import '../note.dart';
import '../piano_roll_model.dart';

class NoteRemoveEdit implements UndoableEdit {
  PianoRollModel model;
  Beat beat;
  Note note;

  NoteRemoveEdit(this.model, this.beat, this.note) {}

  @override
  void redo() {
    model.beginApplyUndoableEdit();
    try {
      note.removeFromBeat();
    } finally {
      model.endApplyUndoableEdit();
    }
  }

  @override
  void undo() {
    model.beginApplyUndoableEdit();
    try {
      beat.restoreNote(note);
    } finally {
      model.endApplyUndoableEdit();
    }
  }
}
