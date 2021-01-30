import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                    onPressed: () {
                      copyToClipboard("AppData");
                    },
                    child: Text('クリップボードにコピー'),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () {
                      pasteFromClipboard("AppData");
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
                    onPressed: () {
                      copyToClipboard("ProjectList");
                    },
                    child: Text('クリップボードにコピー'),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    onPressed: () {
                      pasteFromClipboard("ProjectList");
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

  void copyToClipboard(String key) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("セーブデータをコピー"),
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
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("セーブデータを上書き"),
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
                final data = await Clipboard.getData("text/plain");
                var prefs = await SharedPreferences.getInstance();
                prefs.setString(key, data.text);
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
}
