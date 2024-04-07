
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropToolCorner extends StatefulWidget {
  final int index;
  final int cornerIndex;
  final CropToolRepo cropToolRepo;

  Point<double> getCornerPosition() {
    return cropToolRepo.getCropToolCorner(index, cornerIndex);
  }

  void moveCorner(Offset delta) {
    return cropToolRepo.moveCorner(index, cornerIndex, delta);
  }

  listenCornerChanges(VoidCallback cb) {
    return cropToolRepo.listenCropTool(index, cb);
  }

  const CropToolCorner(this.index, this.cornerIndex, this.cropToolRepo, {super.key});

  @override
  CropToolCornerState createState() => CropToolCornerState();
}

class CropToolCornerState extends State<CropToolCorner> {
  @override
  void initState() {
    super.initState();
    widget.listenCornerChanges(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    final cornerPosition = widget.getCornerPosition();
    return Positioned(
      top: cornerPosition.y - 25,
      left: cornerPosition.x - 25,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.moveCorner(details.delta);
          });
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(0, 255, 0, 0.5),
              border: Border.all(width: 1, color: Colors.red)),
          child: Text(widget.cornerIndex.toString()),
        ),
      ),
    );
  }
}