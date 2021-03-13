import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:next_synth/core/system/app_data.dart';
import 'package:next_synth/core/system/app_data.save_data.dart';
import 'package:next_synth/core/system/project_list.dart';
import 'package:next_synth/core/system/project_list.save_data.dart';
import 'package:save_data_lib/save_data_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './code_page.dart';

class CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    final projectIndex = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('NextSynth'),
      ),
      //appBar: AppBar(
      //  // Here we take the value from the MyHomePage object that was created by
      //  // the App.build method, and use it to set our appbar title.
      //  title: Text(widget.title),
      //),
      body: Center(
          child: Column(
        children: [
          Text(
            'セーブデータの編集',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              Text('設定データJSON'),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () async {
                      await copyToClipboard("AppData");
                    },
                    child: Text('クリップボードにコピー'),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () async {
                      await pasteFromClipboard("AppData");
                    },
                    child: Text('クリップボードから貼り付け'),
                  )),
            ],
          ),
          Row(
            //alignment: MainAxisAlignment.start,
            children: [
              Text('プロジェクトデータJSON'),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () async {
                      await copyToClipboard("ProjectList");
                    },
                    child: Text('クリップボードにコピー'),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () async {
                      await pasteFromClipboard("ProjectList");
                    },
                    child: Text('クリップボードから貼り付け'),
                  )),
            ],
          ),
          Text(
            '※この操作は危険です。注意して実行してください。',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                foreground: Paint()..color = Colors.red),
          ),
        ],
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> copyToClipboard(String key) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(children: [Icon(Icons.warning), Text("セーブデータをコピー")]),
          content: Text("セーブデータの内容をクリップボードへコピーします。\nよろしいですか？"),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                var data = prefs.getString(key);
                if (data == null) {
                  // まだ保存されてない場合へ変換
                  if (key == "ProjectList") {
                    data = json
                        .encode(ProjectListProvider.provide().value.toJson());
                  } else if (key == "AppData") {
                    data =
                        json.encode(AppDataProvider.provide().value.toJson());
                  }
                }
                await Clipboard.setData(ClipboardData(text: data));
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "セーブデータからコピーしました。",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pasteFromClipboard(String key) async {
    // 貼り付け時はデータを検証する必要がある
    final data = await Clipboard.getData("text/plain");
    final prefs = await SharedPreferences.getInstance();
    if (!isValidSaveData(key, data.text)) {
      Fluttertoast.showToast(
          msg: "クリップボードの内容がセーブデータとして認識できません。",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    // データに問題がなければあとはユーザに確認
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(children: [Icon(Icons.warning), Text("セーブデータを上書き")]),
          content: Text("セーブデータの内容をクリップボードの内容で上書きします。\nよろしいですか？"),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () async {
                prefs.setString(key, data.text);
                await SaveData.instance.discard(key);
                await SaveData.instance.load(key);
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "セーブデータを上書きしました。",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
          ],
        );
      },
    );
  }

  bool isValidSaveData(String key, String data) {
    try {
      if (key == "ProjectList") {
        // JSONとしてパースできたがProjectListではない場合
        final plist = ProjectList.fromJson(json.decode(data));
        if (plist == null || !plist.isValid()) {
          debugPrint("ProjectList is not valid");
          return false;
        }
      } else if (key == "AppData") {
        // JSONとしてパースできたがAppDataではない場合
        final appdata = AppData.fromJson(json.decode(data));
        if (appdata == null || !appdata.isValid()) {
          debugPrint("AppData is not valid");
          return false;
        }
      } else {
        return false;
      }
      return true;
    } catch (FormatException) {
      // そもそもJSONではない場合
      debugPrint("FormatException $key $data");
      return false;
    }
  }
}
