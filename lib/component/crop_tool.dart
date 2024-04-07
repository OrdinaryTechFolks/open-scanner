import 'package:open_scanner/component/crop_tool_corner.dart';
import 'package:open_scanner/component/crop_tool_edge.dart';
import 'package:open_scanner/component/crop_tool_plane.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropTool extends StatelessWidget {
  final int index;
  final CropToolRepo cropToolRepo;

  int getCornersLength() {
    return cropToolRepo.getCropToolCornersLength(index);
  }

  int getEdgesLength() {
    return cropToolRepo.getEdgesLength(index);
  }

  const CropTool(this.index, this.cropToolRepo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CropToolPlane(index, cropToolRepo),
        for (int i = 0; i < getCornersLength(); i++) 
          CropToolCorner(index, i, cropToolRepo),
        for (int i = 0; i < getEdgesLength(); i++)
          CropToolEdge(index, i, cropToolRepo)
      ],
    );
  }
}
