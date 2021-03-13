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
    return Scaffold(
      appBar: AppBar(
        title: const Text('NextSynth'),
      ),
      //appBar: AppBar(
      //  // Here we take the value from the MyHomePage object that was created by
      //  // the App.build method, and use it to set our appbar title.
      //  title: Text(widget.title),
      //),
      body: Center(
          child: Column(
        children: [
          const Text(
            'セーブデータの編集',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              const Text('設定データJSON'),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await copyToClipboard('AppData');
                    },
                    child: const Text('クリップボードにコピー'),
                  )),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await pasteFromClipboard('AppData');
                    },
                    child: const Text('クリップボードから貼り付け'),
                  )),
            ],
          ),
          Row(
            //alignment: MainAxisAlignment.start,
            children: [
              const Text('プロジェクトデータJSON'),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await copyToClipboard('ProjectList');
                    },
                    child: const Text('クリップボードにコピー'),
                  )),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await pasteFromClipboard('ProjectList');
                    },
                    child: const Text('クリップボードから貼り付け'),
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
    await showDialog<dynamic>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(children: const [Icon(Icons.warning), Text('セーブデータをコピー')]),
          content: const Text('セーブデータの内容をクリップボードへコピーします。\nよろしいですか？'),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var data = prefs.getString(key);
                if (data == null) {
                  // まだ保存されてない場合へ変換
                  if (key == 'ProjectList') {
                    data = json
                        .encode(ProjectListProvider.provide().value.toJson());
                  } else if (key == 'AppData') {
                    data =
                        json.encode(AppDataProvider.provide().value.toJson());
                  }
                }
                await Clipboard.setData(ClipboardData(text: data));
                Navigator.pop(context);
                await Fluttertoast.showToast(
                    msg: 'セーブデータからコピーしました。',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> pasteFromClipboard(String key) async {
    // 貼り付け時はデータを検証する必要がある
    final data = await Clipboard.getData('text/plain');
    final prefs = await SharedPreferences.getInstance();
    if (!isValidSaveData(key, data.text)) {
      await Fluttertoast.showToast(
          msg: 'クリップボードの内容をセーブデータとして認識できません。',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    // データに問題がなければあとはユーザに確認
    await showDialog<dynamic>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(children: const [Icon(Icons.warning), Text('セーブデータを上書き')]),
          content: const Text('セーブデータの内容をクリップボードの内容で上書きします。\nよろしいですか？'),
          actions: <Widget>[
            // ボタン領域
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await prefs.setString(key, data.text);
                SaveData.instance.discard(key);
                await SaveData.instance.load<dynamic>(key);
                Navigator.pop(context);
                await Fluttertoast.showToast(
                    msg: 'セーブデータを上書きしました。',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool isValidSaveData(String key, String data) {
    try {
      if (key == 'ProjectList') {
        // JSONとしてパースできたがProjectListではない場合
        final plist = ProjectList.fromJson(json.decode(data));
        if (plist == null || !plist.isValid()) {
          debugPrint('ProjectList is not valid');
          return false;
        }
      } else if (key == 'AppData') {
        // JSONとしてパースできたがAppDataではない場合
        final appdata = AppData.fromJson(json.decode(data));
        if (appdata == null || !appdata.isValid()) {
          debugPrint('AppData is not valid');
          return false;
        }
      } else {
        return false;
      }
      return true;
    } catch (FormatException) {
      // そもそもJSONではない場合
      debugPrint('FormatException $key $data');
      return false;
    }
  }
}
