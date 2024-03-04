import 'dart:math';

import 'package:flutter/widgets.dart';

class CropToolDomain {
  late List<Point<double>> cornerPositions;
  final ValueNotifier<int> cornerNotifier = ValueNotifier(0);

  static Point<double> _deltaToPosition(Point<double> previousPosition, Offset delta) {
    return Point(
      max(0, previousPosition.x + delta.dx),
      max(0, previousPosition.y + delta.dy),
    );
  }

  void _setPosition(Offset delta) {
    cornerPositions = cornerPositions
        .map((p) => _deltaToPosition(p, delta))
        .toList(growable: false);
    cornerNotifier.value++;
  }

  CropToolDomain(Offset delta) {
    cornerPositions = [
      const Point(0, 0),
      const Point(144, 0),
      const Point(0, 256),
      const Point(144, 256)
    ];
    _setPosition(delta);
  }

  void move(Offset delta) {
    _setPosition(delta);
  }

  Point<double> getCorner(int index) {
    return cornerPositions[index];
  }

  void moveCorner(int index, Offset delta) {
    cornerPositions[index] = _deltaToPosition(cornerPositions[index], delta);
    cornerNotifier.value++;
  }
}
