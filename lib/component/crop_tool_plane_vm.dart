
import 'package:bgm_frontend/domain/crop_tool.dart';
import 'package:bgm_frontend/repo/resources.dart';
import 'package:flutter/material.dart';

class CropToolPlaneVM {
  late int index;
  late ResourcesRepo repo;

  CropToolPlaneVM(this.index, this.repo);

  listenCornerChanges(VoidCallback cb) {
    return repo.cropTools[index].cornerNotifier.addListener(cb);
  }

  void moveCropTool(Offset delta) {
    return repo.cropTools[index].move(delta);
  }

  CropToolDomain getCropTool() {
    return repo.cropTools[index];
  }
}
