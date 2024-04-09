import 'package:open_scanner/component/crop_tool_corner.dart';
import 'package:open_scanner/component/crop_tool_edge.dart';
import 'package:open_scanner/component/crop_tool_plane.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropTool extends StatelessWidget {
  final CropToolRepo cropToolRepo;

  int getCornersLength() {
    return cropToolRepo.tool.getCornersLength();
  }

  int getEdgesLength() {
    return cropToolRepo.tool.getEdgesLength();
  }

  const CropTool(this.cropToolRepo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CropToolPlane(cropToolRepo),
        for (int i = 0; i < getCornersLength(); i++)
          CropToolCorner(i, cropToolRepo),
        for (int i = 0; i < getEdgesLength(); i++) CropToolEdge(i, cropToolRepo)
      ],
    );
  }
}
