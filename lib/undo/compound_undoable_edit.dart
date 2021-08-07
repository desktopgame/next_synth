import './undoable_edit.dart';

class CompoundUndoableEdit implements UndoableEdit {
  List<UndoableEdit> _edits;

  CompoundUndoableEdit({List<UndoableEdit> edits}) {
    if (edits == null) {
      edits = [];
    } else {
      edits = []..addAll(edits);
    }
    this._edits = edits;
  }

  @override
  void redo() {
    for (var edit in _edits) edit.redo();
  }

  @override
  void undo() {
    for (var edit in _edits) edit.undo();
  }
}
