import 'dart:math';

import 'package:bgm_frontend/component/crop_tool_vm.dart';
import 'package:flutter/material.dart';

class CropToolCornerVM {
  late int index;
  late CropToolVM vm;

  CropToolCornerVM(this.index, this.vm);

  Point<double> get position {
    return vm.getCorner(index);
  }

  void move(Offset delta) {
    return vm.moveCorner(index, delta);
  }
}
