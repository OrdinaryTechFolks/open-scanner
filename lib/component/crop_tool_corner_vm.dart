import 'dart:math';

import 'package:bgm_frontend/repo/resources.dart';
import 'package:flutter/material.dart';

class CropToolCornerVM {
  late int ctIndex;
  late int index;
  late ResourcesRepo resourcesRepo;

  CropToolCornerVM(this.ctIndex, this.index, this.resourcesRepo);

  Point<double> getCornerPosition() {
    return resourcesRepo.cropTools[ctIndex].getCorner(index);
  }

  void moveCorner(Offset delta) {
    return resourcesRepo.cropTools[ctIndex].moveCorner(index, delta);
  }

  listenCornerChanges(VoidCallback cb) {
    return resourcesRepo.cropTools[ctIndex].cornerNotifier.addListener(cb);
  }
}
