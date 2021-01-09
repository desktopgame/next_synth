import 'dart:async';

import 'package:flutter/material.dart';

import '../undo/undoable_edit_event.dart';
import '../undo/undoable_edit_listener.dart';
import 'piano_roll_model.dart';
import 'piano_roll_model_event.dart';
import 'piano_roll_model_listener.dart';

class ToolBar extends StatelessWidget
    implements PianoRollModelListener, UndoableEditListener {
  final PianoRollModel _model;
  final StreamController<UndoableEditEvent> _undoController;
  final StreamController<UndoableEditEvent> _redoController;

  ToolBar(this._model)
      : this._undoController = StreamController<UndoableEditEvent>(),
        this._redoController = StreamController<UndoableEditEvent>() {
    _model.addPianoRollModelListener(this);
    _model.addUndoableEditListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonBar(
        alignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.help),
          ),
          StreamBuilder(
              stream: _undoController.stream,
              builder: (builder, snapshot) {
                return IconButton(
                  onPressed: _model.canUndo
                      ? () {
                          _model.undo();
                        }
                      : null,
                  icon: Icon(Icons.undo),
                );
              }),
          StreamBuilder(
              stream: _redoController.stream,
              builder: (builder, snapshot) {
                return IconButton(
                  onPressed: _model.canRedo
                      ? () {
                          _model.redo();
                        }
                      : null,
                  icon: Icon(Icons.redo),
                );
              }),
          Divider(color: Colors.black),
          IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
          IconButton(onPressed: () {}, icon: Icon(Icons.pause)),
          IconButton(onPressed: () {}, icon: Icon(Icons.stop)),
          Text("ProjectName")
        ],
      ),
      color: Colors.cyan,
    );
  }

  @override
  void pianoRollModelUpdate(PianoRollModelEvent e) {}

  @override
  void undoableEdit(UndoableEditEvent e) {
    _undoController.sink.add(e);
    _redoController.sink.add(e);
  }
}
