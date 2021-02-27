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
            ..keyCount = proj.keyCount
            ..measureCount = proj.measureCount
            ..beatCount = proj.beatCount,
          onChanged: (v, e) async {
            proj
              ..keyCount = v.keyCount
              ..measureCount = v.measureCount
              ..beatCount = v.beatCount;
            for (var t in proj.tracks) {
              t.pianoRollData
                ..keyCount = v.keyCount
                ..measureCount = v.measureCount
                ..beatCount = v.beatCount;
            }
            await ProjectListProvider.save();
          },
        ),
      ),
    );
  }
}
