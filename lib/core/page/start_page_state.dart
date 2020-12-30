import 'package:flutter/material.dart';
import './start_page.dart';
import '../system/project.dart';
import '../system/project_list.dart';
import '../system/project_list.save_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        child: new Dialog(
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
        ),
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
      projectList.data.add(Project()..name = name);
      ProjectListProvider.save();
    });
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
        onPressed: () {
          _deleteProject(this._selectedProjectIndex);
        },
      ),
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {},
      ),
    ];
  }

  Widget _buildGridTile(BuildContext context, int index) {
    var proj = ProjectListProvider.provide().value.data[index];
    return GestureDetector(
        onTap: () {
          print('tap ${this._selectedProjectIndex}');
          _selectProject(index);
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
          persistentFooterButtons: footerButtons,
          body: Center(
            child: Text("プロジェクトがありません。", textAlign: TextAlign.center),
          ));
    }
    // プロジェクト一覧の表示
    return Scaffold(
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
