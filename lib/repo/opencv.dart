import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:bgm_frontend/domain/image.dart';
import 'package:bgm_frontend/repo/opencv.entity.dart';
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
    final destSize = ui.Size(srcImage.size.width / 2, srcImage.size.height / 2);
    final destData = transformFFI(
      srcImage.toCImage(),
      srcCorners.toListPointer(),
      destSize.toCSize(),
    );

    var destLiseLength = destData.width * destData.height * destData.channels;
    var destList = destData.data.asTypedList(destLiseLength);

    return ImageDomain(destSize, srcImage.channels, destList);
  }
}