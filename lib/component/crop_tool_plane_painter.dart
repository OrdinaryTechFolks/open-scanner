
import 'package:flutter/material.dart';
import 'package:open_scanner/component/crop_tool_plane.dart';

class CropToolPlanePainter extends CustomPainter {
  late Path path;

  CropToolPlanePainter(CropToolPlane parent) {
    final corners = parent.getCropToolCorners();
    path = Path()
      ..moveTo(corners[0].x, corners[0].y)
      ..lineTo(corners[1].x, corners[1].y)
      ..lineTo(corners[3].x, corners[3].y)
      ..lineTo(corners[2].x, corners[2].y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color.fromRGBO(255, 0, 0, 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool hitTest(Offset position) {
    return path.contains(position);
  }
}
