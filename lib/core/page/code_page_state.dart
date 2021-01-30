import 'package:flutter/material.dart';

import './code_page.dart';

class CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    final projectIndex = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      //appBar: AppBar(
      //  // Here we take the value from the MyHomePage object that was created by
      //  // the App.build method, and use it to set our appbar title.
      //  title: Text(widget.title),
      //),
      body:
          Center(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
