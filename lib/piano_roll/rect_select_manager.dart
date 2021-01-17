import 'dart:math';

import 'package:flutter/material.dart';

class RectSelectManager {
  Offset rectStart = Offset(0, 0);
  Offset rectEnd = Offset(0, 0);
  bool enabled = false;

  RectSelectManager();

  Rect get selectionRect {
    double minX = min(rectStart.dx, rectEnd.dx);
    double minY = min(rectStart.dy, rectEnd.dy);
    double maxX = max(rectStart.dx, rectEnd.dx);
    double maxY = max(rectStart.dy, rectEnd.dy);
    double x = minX;
    double y = minY;
    double w = maxX - minX;
    double h = maxY - minY;
    return Rect.fromLTRB(x, y, x + w, y + h);
  }
}
