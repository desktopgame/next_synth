import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_synth/piano_roll/default_piano_roll_model.dart';
import 'package:next_synth_midi/next_synth_midi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './start_page.dart';
import './tutorial.dart';
import '../system/midi_helper.dart';
import '../system/app_data.save_data.dart';
import '../system/piano_roll_data.dart';
import '../system/project.dart';
import '../system/project_list.save_data.dart';
import '../system/track_data.dart';

class StartPageState extends State<StartPage> with WidgetsBindingObserver {
  int _selectedProjectIndex;
  GlobalKey _webButtonKey = GlobalKey();
  GlobalKey _addButtonKey = GlobalKey();
  GlobalKey _delButtonKey = GlobalKey();
  GlobalKey _midiButtonKey = GlobalKey();
  GlobalKey _settingButtonKey = GlobalKey();
  GlobalKey _codeButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    this._selectedProjectIndex = -1;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.detached) {
      return;
    }
    // 起動回数を数える
    // 初回起動時のみチュートリアルなどあるため
    AppDataProvider.provide().value.launchCount++;
    // 終了前に保存する
    await AppDataProvider.save();
    await ProjectListProvider.save();
    // MIDI接続を閉じる
    await NextSynthMidi.unregisterDeviceCallback();
    MidiHelper.instance.closeAll();
  }

  static void _showConfirmDialog(BuildContext context, String placeholder,
      {String approveText = "OK",
      String cancelText = "Cancel",
      Color color = Colors.lightBlue,
      void Function(TextEditingController controller) onApprrove,
      void Function(TextEditingController controller) onCancel}) {
    var controller = TextEditingController();
    showDialog<dynamic>(
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
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
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(hintText: placeholder),
                        controller: controller,
                      ),
                      Row(children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            onCancel(controller);
                          },
                          child: Text(cancelText),
                        ),
                        TextButton(
                          onPressed: () {
                            onApprrove(controller);
                          },
                          child: Text(approveText),
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
    if (name == null || name.isEmpty) {
      Fluttertoast.showToast(
          msg: 'プロジェクト名が空です。',
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
    showDialog<dynamic>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('本当に削除しますか？'),
          //content: Text("メッセージメッセージメッセージメッセージメッセージメッセージ"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteProject(i);
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
    var dialogColor = AppDataProvider.provide().value.darkTheme
        ? Colors.black
        : Colors.lightBlue;
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.help),
        onPressed: () {
          _runTutorial();
        },
      ),
      IconButton(
        key: _webButtonKey,
        icon: const Icon(Icons.open_in_browser),
        onPressed: () async {
          const url = 'https://desktopgame.github.io/NextSynth';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            Fluttertoast.showToast(
                msg: "ブラウザを起動できませんでした。",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
      IconButton(
        key: _addButtonKey,
        icon: const Icon(Icons.add),
        onPressed: () {
          _showConfirmDialog(context, 'プロジェクト名',
              onApprrove: (TextEditingController controller) {
            Navigator.pop(context);
            _newProject(controller.text);
          }, onCancel: (TextEditingController controller) {
            Navigator.pop(context);
          }, color: dialogColor);
        },
      ),
      IconButton(
        key: _delButtonKey,
        icon: const Icon(Icons.delete),
        onPressed: _selectedProjectIndex == -1
            ? null
            : () {
                _cofirmDelete(context, this._selectedProjectIndex);
              },
      ),
      IconButton(
        key: _midiButtonKey,
        icon: const Icon(Icons.usb),
        onPressed: () async {
          await Navigator.pushNamed(context, '/usb');
        },
      ),
      IconButton(
        key: _settingButtonKey,
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.pushNamed(context, '/setting');
        },
      ),
      IconButton(
        key: _codeButtonKey,
        icon: const Icon(Icons.code),
        onPressed: () async {
          await Navigator.pushNamed(context, '/code');
          // プロジェクト一覧を再読み込み
          setState(() {});
        },
      ),
    ];
  }

  Widget _buildGridTile(BuildContext context, int index) {
    var proj = ProjectListProvider.provide().value.data[index];
    var notSelColor = AppDataProvider.provide().value.darkTheme
        ? Colors.grey
        : Colors.teal[100];
    return GestureDetector(
        onTap: () {
          if (index == _selectedProjectIndex) {
            AppDataProvider.provide().value.lastOpenProjectIndex = index;
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
          color:
              index == this._selectedProjectIndex ? Colors.blue : notSelColor,
        ));
  }

  void _runTutorial() {
    Tutorial.run([
      TutorialPhase(_webButtonKey, "ヘルプページへ移動します。"),
      TutorialPhase(_addButtonKey, "プロジェクトを作成できます。"),
      TutorialPhase(_delButtonKey, "プロジェクトを削除できます。"),
      TutorialPhase(_midiButtonKey, "MIDI機器との接続を設定できます。"),
      TutorialPhase(_settingButtonKey, "アプリケーション全体の設定を編集できます。"),
      TutorialPhase(_codeButtonKey, "セーブデータのバックアップ/移行のために使用できます。"),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var projects = ProjectListProvider.provide().value.data;
    var footerButtons = _buildFooterButtons(context);
    // プロジェクトが一つもない
    if (projects.length == 0) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('NextSynth'),
          ),
          persistentFooterButtons: footerButtons,
          body: const Center(
            child: Text('プロジェクトがありません。', textAlign: TextAlign.center),
          ));
    }
    // プロジェクト一覧の表示
    return Scaffold(
      appBar: AppBar(
        title: const Text('NextSynth'),
      ),
      body: Center(
          child: GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return _buildGridTile(context, index);
        },
        itemCount: ProjectListProvider.provide().value.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
