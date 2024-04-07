import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_scanner/component/crop_tool_plane_painter.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropToolPlane extends StatefulWidget {
  final CropToolRepo cropToolRepo;

  listenCornerChanges(VoidCallback cb) {
    return cropToolRepo.tool.listen(cb);
  }

  void moveCropTool(Offset delta) {
    return cropToolRepo.tool.moveCropTool(delta);
  }

  List<Point<double>> getCropToolCorners() {
    return cropToolRepo.tool.getCorners();
  }

  const CropToolPlane(this.cropToolRepo, {super.key});

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
        painter: CropToolPlanePainter(widget.cropToolRepo.tool),
        child: Container(),
      ),
    );
  }
}