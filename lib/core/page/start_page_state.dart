import 'package:flutter/material.dart';
import './start_page.dart';

class StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/edit");
          },
          child: Text("PushMe"),
        ),
      ),
    );
  }
}
