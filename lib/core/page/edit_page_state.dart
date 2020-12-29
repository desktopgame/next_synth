import 'package:flutter/material.dart';
import './edit_page.dart';
import './main_view.dart';

class EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  // Here we take the value from the MyHomePage object that was created by
      //  // the App.build method, and use it to set our appbar title.
      //  title: Text(widget.title),
      //),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: MainView(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
