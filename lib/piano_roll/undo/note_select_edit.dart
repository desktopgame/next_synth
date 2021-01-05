import 'package:next_synth/undo/undoable_edit.dart';

import '../note.dart';
import '../piano_roll_model.dart';

class NoteSelectEdit implements UndoableEdit {
  PianoRollModel model;
  Note note;
  bool newValue;

  NoteSelectEdit(this.model, this.note) {
    this.newValue = note.selected;
  }

  @override
  void redo() {
    model.beginApplyUndoableEdit();
    try {
      note.selected = newValue;
    } finally {
      model.endApplyUndoableEdit();
    }
  }

  @override
  void undo() {
    model.beginApplyUndoableEdit();
    try {
      note.selected = !newValue;
    } finally {
      model.endApplyUndoableEdit();
    }
  }
}
