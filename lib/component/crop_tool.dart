import 'package:bgm_frontend/component/crop_tool_corner.dart';
import 'package:bgm_frontend/component/crop_tool_plane.dart';
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
        ...vm.cornerPositions
            .asMap()
            .keys
            .map((index) => CropToolCorner(vm: CropToolCornerVM(index, vm)))
            .toList(),
        CropToolPlane(vm: vm),
      ],
    );
  }
}
