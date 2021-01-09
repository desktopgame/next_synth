import 'package:stack/stack.dart';

import './compound_undoable_edit.dart';
import './undoable_edit.dart';
import './undoable_edit_event.dart';
import './undoable_edit_listener.dart';

class UndoManager {
  Stack<UndoableEdit> _undoStack;
  Stack<UndoableEdit> _redoStack;
  List<UndoableEdit> _edits;
  List<UndoableEditListener> _listeners;
  int _mode;

  UndoManager() {
    this._undoStack = Stack<UndoableEdit>();
    this._redoStack = Stack<UndoableEdit>();
    this._edits = List<UndoableEdit>();
    this._mode = 0;
    this._listeners = List<UndoableEditListener>();
  }

  void addUndoableEditListener(UndoableEditListener listener) {
    _listeners.add(listener);
  }

  void removeUndoableEditListener(UndoableEditListener listener) {
    _listeners.remove(listener);
  }

  void _fire(UndoableEditEvent e) {
    for (var listener in _listeners) {
      listener.undoableEdit(e);
    }
  }

  void beginCompoundEdit() {
    _mode++;
  }

  void submit(UndoableEdit edit) {
    _submit(edit, false);
  }

  void commit(UndoableEdit edit) {
    _submit(edit, true);
  }

  void _submit(UndoableEdit edit, bool exec) {
    if (_mode == 0) {
      if (exec) {
        edit.redo();
      }
      _undoStack.push(edit);
    } else {
      _edits.add(edit);
    }
    _fire(UndoableEditEvent(this));
  }

  void endCompoundEdit() {
    _mode--;
    if (_mode == 0) {
      commit(CompoundUndoableEdit(edits: _edits));
      _edits.clear();
    }
  }

  void undo() {
    if (canUndo) {
      var edit = _undoStack.pop();
      edit.undo();
      _redoStack.push(edit);
      _fire(UndoableEditEvent(this));
    }
  }

  void redo() {
    if (canRedo) {
      var edit = _redoStack.pop();
      edit.redo();
      _undoStack.push(edit);
      _fire(UndoableEditEvent(this));
    }
  }

  void discardAllEdits() {
    while (_undoStack.isNotEmpty) _undoStack.pop();
    while (_redoStack.isNotEmpty) _redoStack.pop();
    _fire(UndoableEditEvent(this));
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
}
