import 'dart:math';
import 'dart:ui';

import 'package:bgm_frontend/domain/crop_tool.dart';
import 'package:bgm_frontend/domain/image.dart';

class ResourcesRepo {
  late ImageDomain selectedImage;
  List<CropToolDomain> cropTools = [];

  ResourcesRepo();

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

  void moveCropTool(int index, Offset delta) {
    List<Point<double>> newCornerPositions = [];
    for (var i = 0; i < cropTools[index].cornerPositions.length; i++) {
      final newPosition = _getNewPosition(cropTools[index].cornerPositions[i], delta);
      if (!_isPositionValid(newPosition)) return;
      newCornerPositions.add(newPosition);
    }

    cropTools[index].cornerPositions = newCornerPositions;
    cropTools[index].cornerNotifier.value++;
  }

  void moveCorner(int index, int cornerIndex, Offset delta) {
    final newPosition = _getNewPosition(cropTools[index].cornerPositions[cornerIndex], delta);
    if (!_isPositionValid(newPosition)) return;
    cropTools[index].cornerPositions[cornerIndex] = newPosition;
    cropTools[index].cornerNotifier.value++;
  }
}