
import 'dart:math';

import 'package:bgm_frontend/repo/crop_tool.dart';
import 'package:flutter/material.dart';

class CropToolPlaneVM {
  late int index;
  late CropToolRepo cropToolRepo;

  CropToolPlaneVM(this.index, this.cropToolRepo);

  listenCornerChanges(VoidCallback cb) {
    return cropToolRepo.listenCropTool(index, cb);
  }

  void moveCropTool(Offset delta) {
    return cropToolRepo.moveCropTool(index, delta);
  }

  List<Point<double>> getCropToolCorners() {
    return cropToolRepo.getCropToolCorners(index);
  }
}
