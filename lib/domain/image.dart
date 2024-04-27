import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

// Store uncompress images
class ImageDomain {
  ui.Size size;
  int channels;
  Uint8List data;

  ImageDomain(this.size, this.channels, this.data);

  static Future<ImageDomain?> fromEncodedList(Uint8List data) async {
    final image = await decodeImageFromList(data);
    final imageData = (await image.toByteData())?.buffer.asUint8List();
    if (imageData == null) return null;

    return ImageDomain(
        ui.Size(image.width.toDouble(), image.height.toDouble()), 4, imageData);
  }

  Future<Either<Error, Uint8List>> getEncodedList() async {
    Completer<ui.Image?> decodeRes = Completer();
    ui.decodeImageFromPixels(this.data, size.width.toInt(), size.height.toInt(), ui.PixelFormat.rgba8888, (res) {
      decodeRes.complete(res);
    });
    var image = await decodeRes.future;
    if (image == null) return Left(FlutterError("Decoded image return null"));

    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return Left(FlutterError("Converted byte return null"));
    
    return Right(data.buffer.asUint8List()); 
  }
}

class EncodedImageDomain {
  final ui.Size size;
  final Uint8List data;

  EncodedImageDomain(this.size, this.data);
}

Future<Either<Error, EncodedImageDomain>> getEncodedImageDomain(ImageDomain image) async {
  final encodedData = await image.getEncodedList();
  if (encodedData.isLeft) {
    return Left(encodedData.left);
  }

  return Right(EncodedImageDomain(image.size, encodedData.right));
}

extension SizeExts on Size {
  String toStringUI() {
    return "${width.toStringAsFixed(0)} X ${height.toStringAsFixed(0)}";
  }
}