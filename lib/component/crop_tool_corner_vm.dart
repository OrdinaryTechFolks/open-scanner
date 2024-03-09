import 'dart:math';

import 'package:open_scanner/repo/crop_tool.dart';
import 'package:flutter/material.dart';

class CropToolCornerVM {
  late int index;
  late int cornerIndex;
  late CropToolRepo cropToolRepo;

  CropToolCornerVM(this.index, this.cornerIndex, this.cropToolRepo);

  Point<double> getCornerPosition() {
    return cropToolRepo.getCropToolCorner(index, cornerIndex);
  }

  void moveCorner(Offset delta) {
    return cropToolRepo.moveCorner(index, cornerIndex, delta);
  }

  listenCornerChanges(VoidCallback cb) {
    return cropToolRepo.listenCropTool(index, cb);
  }
}
