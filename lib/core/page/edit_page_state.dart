import 'package:flutter/material.dart';

import './edit_page.dart';
import './main_view.dart';

class EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    final projectIndex = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      body: Center(
        child: MainView(projectIndex),
      ),
    );
  }
}
