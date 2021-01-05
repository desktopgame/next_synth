import 'package:flutter_test/flutter_test.dart';
import 'package:next_synth/undo/undo_manager.dart';
import 'package:next_synth/undo/undoable_edit.dart';

class NumberModel {
  int n;
  UndoManager _undoManager;

  NumberModel() {
    this.n = 0;
    this._undoManager = UndoManager();
  }

  UndoManager get undoManager => _undoManager;

  void add(int n) {
    _undoManager.beginCompoundEdit();
    for (int i = 0; i < n; i++) _undoManager.submit(IncrementEdit(this));
    _undoManager.endCompoundEdit();
  }

  void sub(int n) {
    _undoManager.beginCompoundEdit();
    for (int i = 0; i < n; i++) _undoManager.submit(DecrementEdit(this));
    _undoManager.endCompoundEdit();
  }

  void overwrite(int n) {
    _undoManager.submit(SetEdit(this, n));
  }
}

class IncrementEdit implements UndoableEdit {
  NumberModel model;

  IncrementEdit(this.model);

  @override
  void redo() {
    model.n++;
  }

  @override
  void undo() {
    model.n--;
  }
}

class DecrementEdit implements UndoableEdit {
  NumberModel model;

  DecrementEdit(this.model);

  @override
  void redo() {
    model.n--;
  }

  @override
  void undo() {
    model.n++;
  }
}

class SetEdit implements UndoableEdit {
  NumberModel model;
  int n;
  int temp;

  SetEdit(this.model, this.n) {
    this.temp = model.n;
  }

  @override
  void redo() {
    model.n = n;
  }

  @override
  void undo() {
    model.n = temp;
  }
}

void main() {
  NumberModel model;
  setUp(() {
    model = NumberModel();
  });
  group('undo test', () {
    test("1", () {
      model.add(5);
      expect(model.n, 5);
      model.add(15);
      expect(model.n, 20);
      model.undoManager.undo();
      expect(model.n, 5);
      model.undoManager.undo();
      expect(model.n, 0);
      expect(model.undoManager.canUndo, false);
      expect(model.undoManager.canRedo, true);
      model.undoManager.redo();
      expect(model.n, 5);
      model.undoManager.redo();
      expect(model.n, 20);
    });
  });
}
