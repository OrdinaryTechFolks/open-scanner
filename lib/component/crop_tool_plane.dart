
import 'package:bgm_frontend/component/crop_tool_vm.dart';
import 'package:flutter/material.dart';

class CropToolPlane extends StatefulWidget {
  final CropToolVM vm;

  const CropToolPlane({super.key, required this.vm});

  @override
  CropToolPlaneState createState() => CropToolPlaneState();
}

class CropToolPlaneState extends State<CropToolPlane> {
  @override
  void initState() {
    super.initState();
    widget.vm.cornerNotifier.addListener(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          widget.vm.move(details.delta);
        });
      },
      child: CustomPaint(
        painter: CropToolPlanePainter(widget.vm),
        child: Container(),
      ),
    );
  }
}

class CropToolPlanePainter extends CustomPainter {
  late Path path;

  CropToolPlanePainter(CropToolVM vm) {
    path = Path()
      ..moveTo(vm.getCorner(0).x, vm.getCorner(0).y)
      ..lineTo(vm.getCorner(1).x, vm.getCorner(1).y)
      ..lineTo(vm.getCorner(3).x, vm.getCorner(3).y)
      ..lineTo(vm.getCorner(2).x, vm.getCorner(2).y);
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