
import 'package:bgm_frontend/view_model/crop_tool_corner.dart';
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
    widget.vm.vm.cornerNotifier.addListener(() => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.vm.position.y - 15,
      left: widget.vm.position.x - 15,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.vm.move(details.delta);
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