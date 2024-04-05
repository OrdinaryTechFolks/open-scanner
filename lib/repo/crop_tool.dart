import 'dart:math';
import 'package:open_scanner/domain/crop_tool.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:flutter/material.dart';

const List<List<int>> edgeToCornerIndexs = [
  [0, 1],
  [2, 3],
  [0, 2],
  [1, 3]
];

class CropToolRepo {
  late ImageDomain selectedImage;

  List<List<Point<double>>> entities = [];
  List<ValueNotifier<int>> entityNotifiers = [];

  CropToolRepo();

  static Point<double> _getNewPosition(
      Point<double> previousPosition, Offset delta) {
    return Point(previousPosition.x + delta.dx, previousPosition.y + delta.dy);
  }

  bool _isPositionValid(Point<double> position) {
    if (position.x < 0) return false;
    if (position.x > selectedImage.size.width) return false;
    if (position.y < 0) return false;
    if (position.y > selectedImage.size.height) return false;

    return true;
  }

  bool _moveCorners(int index, List<int> cornerIndexs, Offset delta) {
    List<Point<double>> newCornerPositions = [];

    for (final cornerIndex in cornerIndexs) {
      final newPosition = _getNewPosition(entities[index][cornerIndex], delta);
      if (!_isPositionValid(newPosition)) return false;
      newCornerPositions.add(newPosition);
    }

    for (final (i, cornerIndex) in cornerIndexs.indexed) {
      entities[index][cornerIndex] = newCornerPositions[i];
    }

    return true;
  }

  List<Point<double>> getCropToolCorners(int index) {
    return entities[index];
  }

  int getCropToolCornersLength(int index) {
    return entities[index].length;
  }

  void resetCropTools() {
    entities = [];
    entityNotifiers = [];
  }

  void addCropTool(Offset delta) {
    final List<Point<double>> corners = [
      const Point(0, 0),
      const Point(144, 0),
      const Point(0, 256),
      const Point(144, 256)
    ];

    for (var i = 0; i < corners.length; i++) {
      final newPosition = _getNewPosition(corners[i], delta);
      corners[i] = newPosition;
    }

    entities.add(corners);
    entityNotifiers.add(ValueNotifier(0));
  }

  void moveCropTool(int index, Offset delta) {
    final cornerIndexs =
        Iterable<int>.generate(entities[index].length).toList();
    if (!_moveCorners(index, cornerIndexs, delta)) return;
    entityNotifiers[index].value++;
  }

  void listenCropTool(int index, VoidCallback cb) {
    return entityNotifiers[index].addListener(cb);
  }

  Point<double> getCropToolCorner(int index, int cornerIndex) {
    return entities[index][cornerIndex];
  }

  void moveCorner(int index, int cornerIndex, Offset delta) {
    if (!_moveCorners(index, [cornerIndex], delta)) return;
    entityNotifiers[index].value++;
  }

  int getEdgesLength(int index) {
    return edgeToCornerIndexs.length;
  }

  EdgeTransform getEdgeTransform(int index, int edgeIndex) {
    final cornerIndexs = edgeToCornerIndexs[edgeIndex];
    final entity = entities[index];

    final position = Point(
      (entity[cornerIndexs[1]].x + entity[cornerIndexs[0]].x) / 2,
      (entity[cornerIndexs[1]].y + entity[cornerIndexs[0]].y) / 2,
    );

    final rotation = atan2(
      entity[cornerIndexs[1]].y - entity[cornerIndexs[0]].y,
      entity[cornerIndexs[1]].x - entity[cornerIndexs[0]].x,
    );

    return EdgeTransform(position, rotation);
  }

  void moveEdge(int index, int edgeIndex, Offset delta) {
    final cornerIndexs = edgeToCornerIndexs[edgeIndex];
    if (!_moveCorners(index, cornerIndexs, delta)) return;
    entityNotifiers[index].value++;
  }
}
