import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_scanner/component/crop_tool_plane_painter.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropToolPlane extends StatefulWidget {
  final int index;
  final CropToolRepo cropToolRepo;

  listenCornerChanges(VoidCallback cb) {
    return cropToolRepo.listenCropTool(index, cb);
  }

  void moveCropTool(Offset delta) {
    return cropToolRepo.moveCropTool(index, delta);
  }

  List<Point<double>> getCropToolCorners() {
    return cropToolRepo.getCropToolCorners(index);
  }

  const CropToolPlane(this.index, this.cropToolRepo, {super.key});

  @override
  CropToolPlaneState createState() => CropToolPlaneState();
}

class CropToolPlaneState extends State<CropToolPlane> {
  @override
  void initState() {
    super.initState();
    widget.listenCornerChanges(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          widget.moveCropTool(details.delta);
        });
      },
      child: CustomPaint(
        painter: CropToolPlanePainter(widget),
        child: Container(),
      ),
    );
  }
}