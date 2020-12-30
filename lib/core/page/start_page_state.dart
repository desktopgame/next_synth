import 'package:flutter/material.dart';
import './start_page.dart';
import '../system/project.dart';
import '../system/project_list.dart';
import '../system/project_list.save_data.dart';

class StartPageState extends State<StartPage> {
  int _selectedProjectIndex;

  @override
  void initState() {
    super.initState();
    this._selectedProjectIndex = -1;
  }

  List<Widget> _buildFooterButtons() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () => {},
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => {},
      ),
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var projects = ProjectListProvider.provide().value.data;
    var footerButtons = _buildFooterButtons();
    // プロジェクトが一つもない
    if (projects.length == 0) {
      return Scaffold(
          persistentFooterButtons: footerButtons,
          body: Center(
            child: Text("プロジェクトがありません。"),
          ));
    }
    // プロジェクト一覧の表示
    var projectWidgets = <Widget>[];
    for (Project proj in projects) {
      projectWidgets.add(Container(
        padding: const EdgeInsets.all(8),
        child: Text('${proj.name}'),
        color: Colors.teal[100],
      ));
    }
    return Scaffold(
      body: Center(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: projectWidgets,
      )),
      persistentFooterButtons: footerButtons,
    );
  }
}
