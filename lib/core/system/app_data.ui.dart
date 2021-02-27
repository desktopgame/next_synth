// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// PropertyUIGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import './app_data.dart';

class AppDataUI extends StatefulWidget {
  AppData _target;
  List<Widget> _header;
  List<Widget> _footer;
  void Function(AppData, String) _onChanged;
  AppDataUI(this._target,
      {List<Widget> header,
      List<Widget> footer,
      void Function(AppData, String) onChanged}) {
    this._header = header == null ? [] : header;
    this._footer = footer == null ? [] : footer;
    this._onChanged = onChanged;
  }

  @override
  State<StatefulWidget> createState() {
    return AppDataUIState(this._target,
        header: _header, footer: _footer, onChanged: _onChanged);
  }
}

class AppDataUIState extends State<AppDataUI> {
  AppData _target;
  List<Widget> _header;
  List<Widget> _footer;
  void Function(AppData, String) _onChanged;
  TextEditingController _keyCountController;
  TextEditingController _beatWidthController;
  TextEditingController _beatHeightController;
  TextEditingController _measureCountController;
  TextEditingController _beatCountController;
  TextEditingController _beatSplitCountController;
  TextEditingController _keyboardWidthController;
  TextEditingController _toolBarHeightController;
  TextEditingController _launchCountController;
  AppDataUIState(this._target,
      {List<Widget> header,
      List<Widget> footer,
      void Function(AppData, String) onChanged}) {
    this._header = header == null ? [] : header;
    this._footer = footer == null ? [] : footer;
    this._onChanged = onChanged;
  }

  @override
  void initState() {
    super.initState();
    _keyCountController = TextEditingController()
      ..text = _target.keyCount.toString();
    _beatWidthController = TextEditingController()
      ..text = _target.beatWidth.toString();
    _beatHeightController = TextEditingController()
      ..text = _target.beatHeight.toString();
    _measureCountController = TextEditingController()
      ..text = _target.measureCount.toString();
    _beatCountController = TextEditingController()
      ..text = _target.beatCount.toString();
    _beatSplitCountController = TextEditingController()
      ..text = _target.beatSplitCount.toString();
    _keyboardWidthController = TextEditingController()
      ..text = _target.keyboardWidth.toString();
    _toolBarHeightController = TextEditingController()
      ..text = _target.toolBarHeight.toString();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>();
    widgets.addAll(_header);
    widgets.add(_inputInt("オクターブ数", "", false, _keyCountController, (e) {
      this._target.keyCount = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "keyCount");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("拍の横幅", "", false, _beatWidthController, (e) {
      this._target.beatWidth = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "beatWidth");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("拍の縦幅", "", false, _beatHeightController, (e) {
      this._target.beatHeight = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "beatHeight");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("小節の数", "", false, _measureCountController, (e) {
      this._target.measureCount = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "measureCount");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("小節内の拍の数", "", false, _beatCountController, (e) {
      this._target.beatCount = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "beatCount");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("拍の分割数", "", false, _beatSplitCountController, (e) {
      this._target.beatSplitCount = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "beatSplitCount");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("キーボードの横幅", "", false, _keyboardWidthController, (e) {
      this._target.keyboardWidth = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "keyboardWidth");
      }
    }));
    widgets.add(Divider());
    widgets.add(_inputInt("ツールバーの高さ", "", false, _toolBarHeightController, (e) {
      this._target.toolBarHeight = int.parse(e);
      if (this._onChanged != null) {
        this._onChanged(_target, "toolBarHeight");
      }
    }));
    widgets.add(Divider());
    if (!kReleaseMode) {
      widgets.add(_inputBool("デバッグ表示", _target.showDebugLabel, (e) {
        setState(() {
          this._target.showDebugLabel = e;
          if (this._onChanged != null) {
            this._onChanged(_target, "showDebugLabel");
          }
        });
      }));
      widgets.add(Divider());
    }
    widgets.addAll(_footer);
    return _scrollableColumn(context, widgets);
  }

  // helper methods
  Widget _labelWith(String label, Widget widget) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              label,
              textAlign: TextAlign.center,
            )),
        Expanded(child: widget)
      ],
    );
  }

  Widget _scrollableColumn(BuildContext context, List<Widget> children) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) => SizedBox(height: 50, child: children[i]),
        itemCount: children.length,
      ),
    );
  }

  Widget _inputString(String name, String hint, bool readonly,
      TextEditingController controller, void Function(String) onChanged) {
    return _labelWith(
        name,
        TextField(
          readOnly: readonly,
          controller: controller,
          decoration: new InputDecoration(labelText: hint),
          onChanged: onChanged,
        ));
  }

  Widget _inputInt(String name, String hint, bool readonly,
      TextEditingController controller, void Function(String) onChanged) {
    return _labelWith(
        name,
        TextField(
          readOnly: readonly,
          controller: controller,
          decoration: new InputDecoration(labelText: hint),
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ));
  }

  Widget _inputDouble(String name, double minValue, double value,
      double maxValue, void Function(double) onChanged) {
    return _labelWith(
        name,
        Slider(
          value: value,
          min: minValue,
          max: maxValue,
          onChanged: onChanged,
        ));
  }

  Widget _inputBool(String name, bool value, void Function(bool) onChanged) {
    return _labelWith(
        name,
        Switch(
          value: value,
          onChanged: onChanged,
        ));
  }
}
