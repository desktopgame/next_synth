import 'dart:async';

import 'package:flutter/material.dart';

import './tool_bar.dart';
import '../undo/undoable_edit_event.dart';
import '../undo/undoable_edit_listener.dart';
import 'piano_roll_model.dart';
import 'piano_roll_model_event.dart';
import 'piano_roll_model_listener.dart';

class ToolBarState extends State<ToolBar>
    implements PianoRollModelListener, UndoableEditListener {
  final PianoRollModel _model;
  final StreamController<UndoableEditEvent> _undoController;
  final StreamController<UndoableEditEvent> _redoController;
  var _selectedValue = 'タップ選択';
  var _usStates = ["タップ選択", "矩形選択", "ドラッグドロップ"];

  ToolBarState(this._model)
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
          PopupMenuButton<String>(
            initialValue: _selectedValue,
            onSelected: (String s) {
              setState(() {
                _selectedValue = s;
              });
            },
            itemBuilder: (BuildContext context) {
              return _usStates.map((String s) {
                return PopupMenuItem(
                  child: Text(s),
                  value: s,
                );
              }).toList();
            },
          )
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
