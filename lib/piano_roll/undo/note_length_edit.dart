import 'package:next_synth/undo/undoable_edit.dart';

import '../note.dart';
import '../piano_roll_model.dart';

class NoteLengthEdit implements UndoableEdit {
  PianoRollModel model;
  Note note;
  double oldLength;
  double newLength;

  NoteLengthEdit(this.model, this.note, this.oldLength) {
    this.newLength = note.length;
  }

  @override
  void redo() {
    try {
      model.beginApplyUndoableEdit();
      note.length = newLength;
    } finally {
      model.endApplyUndoableEdit();
    }
  }

  @override
  void undo() {
    try {
      model.beginApplyUndoableEdit();
      note.length = oldLength;
    } finally {
      model.endApplyUndoableEdit();
    }
  }
}
