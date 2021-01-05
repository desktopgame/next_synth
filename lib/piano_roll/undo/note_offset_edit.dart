import 'package:next_synth/undo/undoable_edit.dart';

import '../note.dart';
import '../piano_roll_model.dart';

class NoteOffsetEdit implements UndoableEdit {
  PianoRollModel model;
  Note note;
  int oldOffset;
  int newOffset;

  NoteOffsetEdit(this.model, this.note, this.oldOffset) {
    this.newOffset = note.offset;
  }

  @override
  void redo() {
    try {
      model.beginApplyUndoableEdit();
      note.offset = newOffset;
    } finally {
      model.endApplyUndoableEdit();
    }
  }

  @override
  void undo() {
    try {
      model.beginApplyUndoableEdit();
      note.offset = oldOffset;
    } finally {
      model.endApplyUndoableEdit();
    }
  }
}
