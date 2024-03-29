import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/repo/opencv.entity.dart';
import 'package:ffi/ffi.dart';

class OpenCVRepo {
  late VersionFunc versionFFI;
  late TransformFunc transformFFI;

  OpenCVRepo() {
    var lib = Platform.isAndroid
        ? ffi.DynamicLibrary.open('libOpenCV_ffi.so')
        : ffi.DynamicLibrary.process();
      
    versionFFI = lib.lookupFunction<VersionFunc, VersionFunc>('version');
    transformFFI = lib.lookupFunction<TransformFunc, TransformFunc>('transform');
  }

  String version() {
    return versionFFI().toDartString();
  }

  ImageDomain transform(ImageDomain srcImage, List<Point<double>> srcCorners) {
    final widthA = sqrt(pow(srcCorners[0].x - srcCorners[1].x, 2) + pow(srcCorners[0].y - srcCorners[1].y, 2));
    final widthB = sqrt(pow(srcCorners[2].x - srcCorners[3].x, 2) + pow(srcCorners[2].y - srcCorners[3].y, 2));
    final destWidth = max(widthA, widthB);

    final heightA = sqrt(pow(srcCorners[0].x - srcCorners[2].x, 2) + pow(srcCorners[0].y - srcCorners[2].y, 2));
    final heightB = sqrt(pow(srcCorners[1].x - srcCorners[3].x, 2) + pow(srcCorners[1].y - srcCorners[3].y, 2));
    final destHeight = max(heightA, heightB);

    final destRange = [
      Range(srcCorners.map((e) => e.x).reduce(min).toInt(), srcCorners.map((e) => e.x).reduce(max).toInt()),
      Range(srcCorners.map((e) => e.y).reduce(min).toInt(), srcCorners.map((e) => e.y).reduce(max).toInt()),
    ];

    final newCorners = [srcCorners[0], srcCorners[1], srcCorners[3], srcCorners[2]].map((e) => Point<double>(
      e.x - destRange[0].start.toDouble(),
      e.y - destRange[1].start.toDouble(),
    )).toList(growable: false);

    final destSize = ui.Size(destWidth, destHeight);
    final destData = transformFFI(
      srcImage.toCImage(),
      newCorners.toListPointer(),
      destRange.toListPointer(),
      destSize.toCSize(),
    );

    var destLiseLength = destData.width * destData.height * destData.channels;
    var destList = destData.data.asTypedList(destLiseLength);
    var realSize = ui.Size(destData.width.toDouble(), destData.height.toDouble());
    
    return ImageDomain(realSize, srcImage.channels, destList);
  }
}