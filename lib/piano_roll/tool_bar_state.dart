import 'dart:async';

import 'package:flutter/material.dart';
import 'package:next_synth/piano_roll/note_resize_manager.dart';
import 'package:next_synth/piano_roll/piano_roll_selection_mode.dart';
import 'package:next_synth/piano_roll/piano_roll_style.dart';
import 'package:next_synth/piano_roll/piano_roll_utilities.dart';

import './tool_bar.dart';
import '../undo/undoable_edit_event.dart';
import '../undo/undoable_edit_listener.dart';
import 'piano_roll_context.dart';
import 'piano_roll_model.dart';
import 'piano_roll_model_event.dart';
import 'piano_roll_model_listener.dart';

class ToolBarState extends State<ToolBar>
    implements PianoRollModelListener, UndoableEditListener {
  final PianoRollContext _context;
  final StreamController<UndoableEditEvent> _undoController;
  final StreamController<UndoableEditEvent> _redoController;
  var _resizeStartX = -1.0;
  var _resizeStarted = false;
  var _resizeTicks = 0;
  var _selectedValue = 'タップ選択';
  var _usStates = ["タップ選択", "矩形選択"];

  ToolBarState(this._context)
      : this._undoController = StreamController<UndoableEditEvent>(),
        this._redoController = StreamController<UndoableEditEvent>() {
    _model.addPianoRollModelListener(this);
    _model.addUndoableEditListener(this);
  }

  PianoRollModel get _model => _context.model;
  PianoRollStyle get _style => _context.style;

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
            initialValue: _context.selectionMode == PianoRollSelectionMode.tap
                ? _usStates[0]
                : _usStates[1],
            onSelected: (String s) {
              setState(() {
                if (s == _usStates[0]) {
                  _context.selectionMode = PianoRollSelectionMode.tap;
                } else if (s == _usStates[1]) {
                  _context.selectionMode = PianoRollSelectionMode.rect;
                }
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
          ),
          GestureDetector(
              onHorizontalDragStart: (DragStartDetails details) {
                _context.noteResizeManager.touchAll(
                    PianoRollUtilities.getAllNoteList(_model)
                        .where((element) => element.selected)
                        .toList());
                _resizeStartX = details.localPosition.dx;
                _resizeTicks = 0;
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                double x = details.localPosition.dx;
                double y = details.localPosition.dy;
                if (this._resizeTicks < 10) {
                  this._resizeTicks++;
                  return;
                }
                if (!this._resizeStarted) {
                  this._resizeStarted = true;
                  if (x < _resizeStartX) {
                    _context.noteResizeManager
                        .start(NoteResizeType.move, x.toInt());
                  } else {
                    _context.noteResizeManager
                        .start(NoteResizeType.resize, x.toInt());
                  }
                } else {
                  _context.noteResizeManager
                      .resize(x.toInt(), _style.beatWidth);
                }
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                this._resizeStarted = false;
              },
              child: Container(
                child: Text("ここをスワイプでリサイズ"),
                color: Colors.white,
              )),
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
