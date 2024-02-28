import 'package:bgm_frontend/component/crop_tool.dart';
import 'package:bgm_frontend/component/crop_tool_vm.dart';
import 'package:bgm_frontend/domain/domain.image.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  final List<CropToolVM> cropToolModel = [
    CropToolVM(const Offset(100, 100))
  ];
  final ImageDomain image;

  DisplayPictureScreen({super.key, required this.image});

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: MemoryImage(widget.image.data),
              ),
            ),
          ),
          Stack(
            children: [
              ...widget.cropToolModel
                  .map((vm) => CropTool(vm: vm))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }
}
