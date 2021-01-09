import './undo_manager.dart';

class UndoableEditEvent {
  UndoManager _undoManager;

  UndoableEditEvent(this._undoManager);

  UndoManager get undoManager => _undoManager;
}
