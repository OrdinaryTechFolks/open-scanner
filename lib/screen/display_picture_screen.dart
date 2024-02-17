
import 'dart:io';

import 'package:bgm_frontend/component/crop_tool.dart';
import 'package:bgm_frontend/view_model/crop_tool.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatefulWidget {
  final List<CropToolVM> cropToolModel = [
    CropToolVM(const Offset(100, 100))
  ];
  final String imagePath;

  DisplayPictureScreen({super.key, required this.imagePath});

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
                fit: BoxFit.contain,
                image: FileImage(File(widget.imagePath)),
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
