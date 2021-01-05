import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './core/page/edit_page.dart';
import './core/page/setting_page.dart';
import './core/page/start_page.dart';
import './core/system/app_data.save_data.dart';
import './core/system/project_list.save_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // セーブデータ登録
  //SaveData.instance.clear();
  AppDataProvider.setup();
  ProjectListProvider.setup();
  await AppDataProvider.load();
  await ProjectListProvider.load();
  // デバッグ時のみセーブデータ確認
  if (kDebugMode) {
    try {
      var appData = AppDataProvider.provide().value;
      debugPrint('AppData=${json.encode(appData.toJson())}');
    } catch (Exception) {
      debugPrint('SaveData: clear');
      AppDataProvider.discard();
      return;
    }
  }
  runApp(MyApp());
  // 起動回数を数える
  // 初回起動時のみチュートリアルなどあるため
  AppDataProvider.provide().value.launchCount++;
  // 終了前に保存する
  await AppDataProvider.save();
  await ProjectListProvider.save();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => StartPage(),
        "/edit": (BuildContext context) => EditPage(),
        "/setting": (BuildContext context) => SettingPage()
      },
    );
  }
}
