import 'dart:math';

import 'package:open_scanner/domain/image.dart';
import 'package:flutter/material.dart';

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

  List<Point<double>> getCropToolCorners(int index) {
    return entities[index];
  }

  int getCropToolCornersLength(int index){
    return entities[index].length;
  }

  void resetCropTools(){
    entities = [];
    entityNotifiers = [];
  }

  void addCropTool(Offset delta){
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
    List<Point<double>> newCornerPositions = [];
    for (var i = 0; i < entities[index].length; i++) {
      final newPosition = _getNewPosition(entities[index][i], delta);
      if (!_isPositionValid(newPosition)) return;
      newCornerPositions.add(newPosition);
    }

    entities[index] = newCornerPositions;
    entityNotifiers[index].value++;
  }


  void listenCropTool(int index, VoidCallback cb) {
    return entityNotifiers[index].addListener(cb);
  }

  Point<double> getCropToolCorner(int index, int cornerIndex) {
    return entities[index][cornerIndex];
  }

  void moveCorner(int index, int cornerIndex, Offset delta) {
    final newPosition = _getNewPosition(entities[index][cornerIndex], delta);
    if (!_isPositionValid(newPosition)) return;
    entities[index][cornerIndex] = newPosition;
    entityNotifiers[index].value++;
  }
}