import 'package:flutter/material.dart';
import 'package:open_scanner/domain/crop_tool.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropToolEdge extends StatefulWidget {
  final int edgeIndex;
  final CropToolRepo cropToolRepo;

  EdgeTransform getEdgeTransform() {
    return cropToolRepo.tool.getEdgeTransform(edgeIndex);
  }

  void moveEdge(Offset delta) {
    return cropToolRepo.tool.moveEdge(edgeIndex, delta);
  }

  listenCornerChanges(VoidCallback cb) {
    return cropToolRepo.tool.listen(cb);
  }

  const CropToolEdge(this.edgeIndex, this.cropToolRepo, {super.key});

  @override
  CropToolEdgeState createState() => CropToolEdgeState();
}

class CropToolEdgeState extends State<CropToolEdge> {
  @override
  void initState() {
    super.initState();
    widget.listenCornerChanges(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    final edgeTransform = widget.getEdgeTransform();
    return Positioned(
      top: edgeTransform.position.y - 15,
      left: edgeTransform.position.x - 45,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.moveEdge(details.delta);
          });
        },
        child: Transform.rotate(
          angle: edgeTransform.rotation,
          child: Container(
            height: 30,
            width: 90,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color.fromRGBO(0, 255, 0, 0.5),
                border: Border.all(width: 1, color: Colors.red)),
            child: Text(widget.edgeIndex.toString()),
          ),
        ),
      ),
    );
  }
}
