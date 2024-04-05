import 'package:flutter/material.dart';
import 'package:open_scanner/repo/crop_tool.dart';

class CropToolEdge extends StatefulWidget {
  final int index;
  final int edgeIndex;
  final CropToolRepo cropToolRepo;

  const CropToolEdge(this.index, this.edgeIndex, this.cropToolRepo,
      {super.key});

  @override
  CropToolEdgeState createState() => CropToolEdgeState();
}

class CropToolEdgeState extends State<CropToolEdge> {
  @override
  void initState() {
    super.initState();
    widget.cropToolRepo.listenCropTool(widget.index, () => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    final edgeTransform =
        widget.cropToolRepo.getEdgeTransform(widget.index, widget.edgeIndex);
    return Positioned(
      top: edgeTransform.position.y - 15,
      left: edgeTransform.position.x - 45,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.cropToolRepo
                .moveEdge(widget.index, widget.edgeIndex, details.delta);
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
