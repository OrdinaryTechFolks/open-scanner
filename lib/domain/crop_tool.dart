import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';

const List<List<int>> edgeToCornerIndexs = [
  [0, 1],
  [2, 3],
  [0, 2],
  [1, 3]
];

class CropToolDomain {
  final List<Point<double>> corners;
  final Size area;
  final ValueNotifier<int> notifier = ValueNotifier(0);

  CropToolDomain(this.corners, this.area);

  (Point<double>, bool) _getNewPosition(
      Point<double> previousPosition, Offset delta) {
    final newX = previousPosition.x + delta.dx;
    if (newX < 0 || newX > area.width) return (const Point(0, 0), false);

    final newY = previousPosition.y + delta.dy;
    if (newY < 0 || newY > area.height) return (const Point(0, 0), false);

    return (Point(newX, newY), true);
  }

  bool _moveCorners(List<int> cornerIndexs, Offset delta) {
    List<Point<double>> newCorners = [];

    for (final cornerIndex in cornerIndexs) {
      final (newPosition, isValid) =
          _getNewPosition(corners[cornerIndex], delta);
      if (!isValid) return false;

      newCorners.add(newPosition);
    }

    for (final (i, cornerIndex) in cornerIndexs.indexed) {
      corners[cornerIndex] = newCorners[i];
    }

    return true;
  }

  void moveCropTool(Offset delta) {
    final cornerIndexs = Iterable<int>.generate(corners.length).toList();
    if (!_moveCorners(cornerIndexs, delta)) return;

    notifier.value++;
  }

  void moveCorner(int cornerIndex, Offset delta) {
    if (!_moveCorners([cornerIndex], delta)) return;
    notifier.value++;
  }

  void moveEdge(int edgeIndex, Offset delta) {
    final cornerIndexs = edgeToCornerIndexs[edgeIndex];
    if (!_moveCorners(cornerIndexs, delta)) return;
    notifier.value++;
  }

  int getCornersLength() {
    return corners.length;
  }

  int getEdgesLength() {
    return edgeToCornerIndexs.length;
  }

  List<Point<double>> getCorners() {
    return corners;
  }

  Point<double> getCorner(int cornerIndex) {
    return corners[cornerIndex];
  }

  EdgeTransform getEdgeTransform(int edgeIndex) {
    final cornerIndexs = edgeToCornerIndexs[edgeIndex];
    final position = Point(
      (corners[cornerIndexs[1]].x + corners[cornerIndexs[0]].x) / 2,
      (corners[cornerIndexs[1]].y + corners[cornerIndexs[0]].y) / 2,
    );

    final rotation = atan2(
      corners[cornerIndexs[1]].y - corners[cornerIndexs[0]].y,
      corners[cornerIndexs[1]].x - corners[cornerIndexs[0]].x,
    );

    return EdgeTransform(position, rotation);
  }

   void listen(VoidCallback cb) {
    return notifier.addListener(cb);
  }
}

class EdgeTransform {
  final Point<double> position;
  final double rotation;

  EdgeTransform(this.position, this.rotation);
}
