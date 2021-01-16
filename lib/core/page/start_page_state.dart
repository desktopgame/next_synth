import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';

import './start_page.dart';
import '../system/app_data.save_data.dart';
import '../system/piano_roll_data.dart';
import '../system/project.dart';
import '../system/project_list.save_data.dart';
import '../system/track_data.dart';

class StartPageState extends State<StartPage> {
  int _selectedProjectIndex;

  @override
  void initState() {
    super.initState();
    this._selectedProjectIndex = -1;
  }

  static void _showConfirmDialog(BuildContext context, String placeholder,
      {String approveText = "OK",
      String cancelText = "Cancel",
      Color color = Colors.lightBlue,
      void Function(TextEditingController controller) onApprrove,
      void Function(TextEditingController controller) onCancel}) {
    var controller = TextEditingController();
    showDialog(
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                    child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: color),
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        decoration: new InputDecoration(hintText: placeholder),
                        controller: controller,
                      ),
                      Row(children: [
                        Spacer(),
                        new FlatButton(
                          child: new Text(cancelText),
                          onPressed: () {
                            onCancel(controller);
                          },
                        ),
                        new FlatButton(
                          child: new Text(approveText),
                          onPressed: () {
                            onApprrove(controller);
                          },
                        ),
                      ]),
                    ],
                  ),
                ))
              ],
            ),
          );
        },
        context: context);
  }

  void _newProject(String name) {
    if (name == null || name.length == 0) {
      Fluttertoast.showToast(
          msg: "プロジェクト名が空です。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      var projectList = ProjectListProvider.provide().value;
      var proj = Project()..name = name;
      var appData = AppDataProvider.provide().value;
      var track = TrackData()
        ..name = "Track1"
        ..pianoRollData = PianoRollData.fromModel(DefaultPianoRollModel(
            appData.keyCount * 12, appData.measureCount, appData.beatCount));
      proj.tracks.add(track);
      projectList.data.add(proj);

      ProjectListProvider.save();
    });
  }

  void _cofirmDelete(BuildContext context, int i) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("本当に削除しますか？"),
          //content: Text("メッセージメッセージメッセージメッセージメッセージメッセージ"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                _deleteProject(i);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProject(int i) {
    setState(() {
      var data = ProjectListProvider.provide().value.data;
      if (i >= 0 && i < data.length) {
        data.removeAt(i);
        this._selectedProjectIndex = -1;
        ProjectListProvider.save();
      }
    });
  }

  void _selectProject(int i) {
    setState(() {
      if (this._selectedProjectIndex == i) {
        i = -1;
      }
      this._selectedProjectIndex = i;
    });
  }

  List<Widget> _buildFooterButtons(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _showConfirmDialog(context, "プロジェクト名",
              onApprrove: (TextEditingController controller) {
            Navigator.pop(context);
            _newProject(controller.text);
          }, onCancel: (TextEditingController controller) {
            Navigator.pop(context);
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: _selectedProjectIndex == -1
            ? null
            : () {
                _cofirmDelete(context, this._selectedProjectIndex);
              },
      ),
      IconButton(
        icon: Icon(Icons.usb),
        onPressed: () async {
          Navigator.pushNamed(context, "/usb");
        },
      ),
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, "/setting");
        },
      ),
    ];
  }

  Widget _buildGridTile(BuildContext context, int index) {
    var proj = ProjectListProvider.provide().value.data[index];
    return GestureDetector(
        onTap: () {
          if (index == _selectedProjectIndex) {
            Navigator.pushNamed(context, "/edit", arguments: index);
          } else {
            _selectProject(index);
          }
        },
        onTapDown: (details) {},
        onTapUp: (details) {},
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text('${proj.name}'),
          color: index == this._selectedProjectIndex
              ? Colors.blue
              : Colors.teal[100],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var projects = ProjectListProvider.provide().value.data;
    var footerButtons = _buildFooterButtons(context);
    // プロジェクトが一つもない
    if (projects.length == 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text('NextSynth'),
          ),
          persistentFooterButtons: footerButtons,
          body: Center(
            child: Text("プロジェクトがありません。", textAlign: TextAlign.center),
          ));
    }
    // プロジェクト一覧の表示
    return Scaffold(
      appBar: AppBar(
        title: Text('NextSynth'),
      ),
      body: Center(
          child: GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return _buildGridTile(context, index);
        },
        itemCount: ProjectListProvider.provide().value.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 4,
        ),
        //children: projectWidgets,
      )),
      persistentFooterButtons: footerButtons,
    );
  }
}
