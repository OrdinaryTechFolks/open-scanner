import 'dart:math';

import 'package:bgm_frontend/repo/resources.dart';
import 'package:flutter/material.dart';

class CropToolCornerVM {
  late int index;
  late int cornerIndex;
  late ResourcesRepo resourcesRepo;

  CropToolCornerVM(this.index, this.cornerIndex, this.resourcesRepo);

  Point<double> getCornerPosition() {
    return resourcesRepo.cropTools[index].getCorner(cornerIndex);
  }

  void moveCorner(Offset delta) {
    return resourcesRepo.moveCorner(index, cornerIndex, delta);
  }

  listenCornerChanges(VoidCallback cb) {
    return resourcesRepo.cropTools[index].cornerNotifier.addListener(cb);
  }
}
