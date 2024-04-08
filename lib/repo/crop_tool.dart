import 'dart:math';
import 'package:open_scanner/domain/crop_tool.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:flutter/material.dart';

class CropToolRepo {
  ImageDomain? selectedImage;
  CropToolDomain? selectedTool;
  List<CropToolDomain> pastTools = [];

  CropToolRepo();

  ImageDomain get image {
    if (selectedImage == null) throw FlutterError("SelectedImage null");
    return selectedImage!;
  } 

  CropToolDomain get tool {
    if (selectedTool == null) throw FlutterError("SelectedTool null");
    return selectedTool!;
  }

  void reset() {
    selectedImage = null;
    selectedTool = null;
    pastTools = [];
  }

  void setImage(ImageDomain img) {
    selectedImage = img;
  }

  void addTool(Offset delta) {
    final List<Point<double>> corners = [
      const Point(0, 0),
      const Point(144, 0),
      const Point(0, 256),
      const Point(144, 256)
    ];

    if (selectedTool != null) {
      pastTools.add(selectedTool!);
    }

    final tool = CropToolDomain(corners, image.size);
    tool.moveCropTool(delta);

    selectedTool = tool;
  }
}
