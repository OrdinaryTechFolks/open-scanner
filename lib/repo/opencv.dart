import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:open_scanner/api/open-scanner-be/v1/opencv.pbgrpc.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/repo/opencv.entity.dart';

class OpenCVRepo {
  OpenCVServiceClient openCVClient;

  OpenCVRepo(this.openCVClient);

  Future<ImageDomain> transform(ImageDomain srcImage,
      List<Point<double>> srcCorners, Size? preferredSize) async {

    final destRange = [
      Range(srcCorners.map((e) => e.x).reduce(min).toInt(), srcCorners.map((e) => e.x).reduce(max).toInt()),
      Range(srcCorners.map((e) => e.y).reduce(min).toInt(), srcCorners.map((e) => e.y).reduce(max).toInt()),
    ];

    final List<int> rangedImgData = [];
    for (var y = destRange[1].start; y <= destRange[1].end; y++) {
      final yOffset = y * srcImage.size.width.toInt() * 4; 
      final start = yOffset + destRange[0].start * 4;
      rangedImgData.addAll(
        srcImage.data.getRange(start, start + destRange[0].length() * 4),
      );
    }

    final newCorners = [srcCorners[0], srcCorners[1], srcCorners[3], srcCorners[2]].map((e) => Point<double>(
      e.x - destRange[0].start.toDouble(),
      e.y - destRange[1].start.toDouble(),
    )).toList(growable: false);

    final destSize = preferredSize ?? getSizeFromCorners(srcCorners);
    final res = await openCVClient.warpPerspective(WarpPerspectiveRequest(
      destSize: Size2f(width: destSize.width, height: destSize.height),
      srcCorners: newCorners.map((e) => Point2f(x: e.x, y: e.y)),
      srcImage: Image(
        channels: srcImage.channels, 
        width: destRange[0].length(), 
        height: destRange[1].length(), 
        data: rangedImgData,
      ),
    ));
  
    return ImageDomain(
      ui.Size(res.width.toDouble(), res.height.toDouble()),
      res.channels,
      Uint8List.fromList(res.data),
    );
  }

  ui.Size getSizeFromCorners(List<Point<double>> srcCorners) {
    final widthA = sqrt(pow(srcCorners[0].x - srcCorners[1].x, 2) + pow(srcCorners[0].y - srcCorners[1].y, 2));
    final widthB = sqrt(pow(srcCorners[2].x - srcCorners[3].x, 2) + pow(srcCorners[2].y - srcCorners[3].y, 2));
    final destWidth = max(widthA, widthB);

    final heightA = sqrt(pow(srcCorners[0].x - srcCorners[2].x, 2) + pow(srcCorners[0].y - srcCorners[2].y, 2));
    final heightB = sqrt(pow(srcCorners[1].x - srcCorners[3].x, 2) + pow(srcCorners[1].y - srcCorners[3].y, 2));
    final destHeight = max(heightA, heightB);

    return ui.Size(destWidth, destHeight);
  }
}
