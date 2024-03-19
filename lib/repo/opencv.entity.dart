
import 'dart:ffi' as ffi;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:open_scanner/domain/image.dart';
import 'package:ffi/ffi.dart';

class Range {
  final int start;
  final int end;

  Range(this.start, this.end);

  @override
  String toString() {
    return "start:$start|end:$end";
  }
}

final class CRange extends ffi.Struct {
  @ffi.Int32()
  external int start;

  @ffi.Int32()
  external int end;
}

final class CImage extends ffi.Struct {
  @ffi.Int32()
  external int width;

  @ffi.Int32()
  external int height;

  @ffi.Int32()
  external int channels;

  external ffi.Pointer<ffi.Uint8> data;
}

final class CPoint extends ffi.Struct {
  @ffi.Float()
  external double x;

  @ffi.Float()
  external double y;
}

final class CSize extends ffi.Struct {
  @ffi.Float()
  external double width;

  @ffi.Float()
  external double height;
}

typedef VersionFunc = ffi.Pointer<Utf8> Function();
typedef TransformFunc = CImage Function(
    ffi.Pointer<CImage>, ffi.Pointer<CPoint>, ffi.Pointer<CRange>, ffi.Pointer<CSize>);

extension ImageDomainExts on ImageDomain {
  ffi.Pointer<CImage> toCImage() {
    ffi.Pointer<CImage> cImage = calloc<CImage>();
    cImage.ref.width = size.width.toInt();
    cImage.ref.height = size.height.toInt();
    cImage.ref.channels = channels;
    cImage.ref.data = data.toUint8Pointer();
    return cImage;
  }
}

extension Uint8ListToUint8Pointer on Uint8List {
  ffi.Pointer<ffi.Uint8> toUint8Pointer() {
    final ptr = malloc.allocate<ffi.Uint8>(ffi.sizeOf<ffi.Uint8>() * length);
    for (var i = 0; i < length; i++) {
      (ptr+i).value = this[i];
    }
    return ptr;
  }
}

extension SizeToCSize on ui.Size {
  ffi.Pointer<CSize> toCSize() {
    ffi.Pointer<CSize> cSize = calloc<CSize>();
    cSize.ref.width = width;
    cSize.ref.height = height;
    return cSize;
  }
}

extension DoublePointListToDoublePointPointer on List<Point<double>> {
  ffi.Pointer<CPoint> toListPointer() {
    final ptr = malloc.allocate<CPoint>(ffi.sizeOf<CPoint>() * length);
    for (var i = 0; i < length; i++) {
      (ptr+i).ref.x = this[i].x;
      (ptr+i).ref.y = this[i].y;
    }
    return ptr;
  }
}

extension RangeListFFI on List<Range> {
  ffi.Pointer<CRange> toListPointer() {
    final ptr = malloc.allocate<CRange>(ffi.sizeOf<CRange>() * length);
    for (var i = 0; i < length; i++) {
      (ptr+i).ref.start = this[i].start;
      (ptr+i).ref.end = this[i].end;
    }
    return ptr;
  }
}