import 'package:flutter/material.dart';

import './setting_page.dart';
import '../system/app_data.save_data.dart';
import '../system/app_data.ui.dart';

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NextSynth'),
      ),
      body: Center(
        child: AppDataUI(
          AppDataProvider.provide().value,
          header: [
            Center(
              child: Text("プロジェクトごとの設定情報を編集できます。"),
            )
          ],
          onChanged: (v, e) async {
            await AppDataProvider.save();
          },
        ),
      ),
    );
  }
}
