
import 'package:bgm_frontend/component/crop_tool_corner_vm.dart';
import 'package:flutter/material.dart';

class CropToolCorner extends StatefulWidget {
  final CropToolCornerVM vm;

  const CropToolCorner({super.key, required this.vm});

  @override
  CropToolCornerState createState() => CropToolCornerState();
}

class CropToolCornerState extends State<CropToolCorner> {
  @override
  void initState() {
    super.initState();
    widget.vm.listenCornerChanges(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    final cornerPosition = widget.vm.getCornerPosition();
    return Positioned(
      top: cornerPosition.y - 15,
      left: cornerPosition.x - 15,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.vm.moveCorner(details.delta);
          });
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(0, 255, 0, 0.5),
              border: Border.all(width: 1, color: Colors.red)),
          child: Text(widget.vm.index.toString()),
        ),
      ),
    );
  }
}