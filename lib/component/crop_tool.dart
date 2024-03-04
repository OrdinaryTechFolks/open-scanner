import 'package:bgm_frontend/component/crop_tool_corner.dart';
import 'package:bgm_frontend/component/crop_tool_plane.dart';
import 'package:bgm_frontend/component/crop_tool_plane_vm.dart';
import 'package:bgm_frontend/component/crop_tool_vm.dart';
import 'package:bgm_frontend/component/crop_tool_corner_vm.dart';
import 'package:flutter/material.dart';

class CropTool extends StatelessWidget {
  final CropToolVM vm;

  const CropTool({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < vm.getCornersLength(); i++) 
          CropToolCorner(vm: CropToolCornerVM(vm.index, i, vm.repo)),
        CropToolPlane(vm: CropToolPlaneVM(vm.index, vm.repo)),
      ],
    );
  }
}
