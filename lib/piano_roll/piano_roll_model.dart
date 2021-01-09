import './key.dart';
import './piano_roll_model_listener.dart';
import '../undo/undoable_edit_listener.dart';

abstract class PianoRollModel {
  void addUndoableEditListener(UndoableEditListener listener);
  void removeUndoableEditListener(UndoableEditListener listener);
  bool get canUndo;
  bool get canRedo;
  void undo();
  void redo();
  void clear();
  PianoRollModel duplicate();
  bool merge(PianoRollModel model);
  void addPianoRollModelListener(PianoRollModelListener listener);
  void removePianoRollModelListener(PianoRollModelListener listener);
  void resizeKeyCount(int keyCount);
  void resizeMeasureCount(int measureCount);
  void resizeBeatCount(int beatCount);
  void beginApplyUndoableEdit();
  void endApplyUndoableEdit();
  void beginCompoundUndoableEdit();
  void endCompoundUndoableEdit();
  int getKeyHeight(int keyIndex);
  Key getKeyAt(int index);
  int get keyCount;
}
