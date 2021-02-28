import 'package:flutter/material.dart';
import 'package:next_synth/core/system/temp_project_data.dart';

import 'project_setting_page.dart';
import '../system/temp_project_data.ui.dart';
import '../system/app_data.save_data.dart';
import '../system/app_data.ui.dart';
import '../system/project.dart';
import '../system/project_list.dart';
import '../system/project_list.save_data.dart';

class ProjectSettingPageState extends State<ProjectSettingPage> {
  @override
  void initState() {
    super.initState();
    AppDataProvider.provide().value.settingUpdated = false;
  }

  @override
  Widget build(BuildContext context) {
    var proj = ProjectListProvider.provide()
        .value
        .data
        .elementAt(AppDataProvider.provide().value.lastOpenProjectIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text('NextSynth'),
      ),
      body: Center(
        child: TempProjectDataUI(
          TempProjectData()
            ..bpm = proj.bpm
            ..keyCount = proj.keyCount
            ..measureCount = proj.measureCount
            ..beatCount = proj.beatCount,
          header: [
            Center(
              child: Text("プロジェクトごとの設定情報を編集できます。"),
            )
          ],
          onChanged: (v, e) async {
            proj
              ..bpm = v.bpm
              ..keyCount = v.keyCount
              ..measureCount = v.measureCount
              ..beatCount = v.beatCount;
            for (var t in proj.tracks) {
              t.pianoRollData
                ..keyCount = v.keyCount * 12
                ..measureCount = v.measureCount
                ..beatCount = v.beatCount;
            }
            AppDataProvider.provide().value.settingUpdated = true;
            await ProjectListProvider.save();
          },
        ),
      ),
    );
  }
}
