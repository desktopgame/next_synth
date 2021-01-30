import 'package:flutter/material.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';

class TutorialPhase {
  GlobalKey key;
  String label;
  double top = 25;
  double right = 10;

  TutorialPhase(this.key, this.label, {this.top, this.right});
}

class Tutorial {
  Tutorial._ctor();

  static void run(
    List<TutorialPhase> phases,
  ) {
    _runSequence(0, phases)();
  }

  static void Function() _runSequence(
    int index,
    List<TutorialPhase> phases,
  ) {
    if (index >= phases.length) {
      return () {};
    }
    return () {
      _runHighlight(phases[index].key, phases[index].label,
          top: phases[index].top,
          right: phases[index].right,
          callback: _runSequence(index + 1, phases));
    };
  }

  static void _runHighlight(GlobalKey key, String label,
      {double top = 25, double right = 10, void Function() callback}) {
    CoachMark coachMark = CoachMark();
    RenderBox target = key.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromCircle(
        center: markRect.center, radius: markRect.longestSide * 0.6);
    coachMark.show(
        targetContext: key.currentContext,
        markRect: markRect,
        children: [
          Positioned(
              top: markRect.top - top,
              right: right,
              child: Text(label,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: null,
        onClose: () {
          if (callback != null) callback();
          //appState.setCoachMarkIsShown(true);
        });
  }
}
