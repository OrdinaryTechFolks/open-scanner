import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _CVersionFunc = ffi.Pointer<Utf8> Function();
typedef _CProcessImageFunc = ffi.Void Function(
    ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _ProcessImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
    ? ffi.DynamicLibrary.open('libOpenCV_ffi.so')
    : ffi.DynamicLibrary.process();

// Looking for the functions
final _VersionFunc _version =
    _lib.lookupFunction<_CVersionFunc, _VersionFunc>('version');
final _ProcessImageFunc _processImage = _lib
    .lookup<ffi.NativeFunction<_CProcessImageFunc>>('process_image')
    .asFunction();

String opencvVersion() {
  return _version().toDartString();
}

void processImage(String inputPath, String outputPath) {
  _processImage(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
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

class Image {
  int width;
  int height;
  int channels;
  Uint8List data;

  Image(this.width, this.height, this.channels, this.data);

  ffi.Pointer<CImage> getCImage() {
    ffi.Pointer<CImage> cImage = calloc<CImage>();
    cImage.ref.width = width;
    cImage.ref.height = height;
    cImage.ref.channels = channels;
    // print("before length ${data.length}");
    cImage.ref.data = data.toUint8Pointer();
    // print("data: $data");
    // print("data: ${cImage.ref.width}");
    return cImage;
  }
}

typedef _TransformFunc = CImage Function(
    ffi.Pointer<CImage>, ffi.Pointer<CPoint>, ffi.Pointer<CSize>);
final _TransformFunc _transform =
    _lib.lookupFunction<_TransformFunc, _TransformFunc>('transform');

Image transform(Image src, List<Point<double>> srcCorners) {
  // print("here1");
  final size = ui.Size(src.width / 2, src.height / 2);
  final tCImg = _transform(
    src.getCImage(),
    srcCorners.toListPointer(),
    size.toCSize(),
  );
  // print("here2");
  // print("here ${tCImg.width} ${tCImg.height}");
  // print("here4 ${tCImg.data.asTypedList(6)}}");
  var list =
      tCImg.data.asTypedList(tCImg.width * tCImg.height * tCImg.channels);
  // var list = Uint8List.fromList([0, 0, 0, 0]);
  // print("data_c: $list");
  // print("data_c: ${list.length}");
  // print("data_c: ${list[list.length-3]} ${list[list.length-2]} ${list[list.length-1]}");
  return Image(tCImg.width, tCImg.height, tCImg.channels, list);
}

extension Uint8ListToUint8Pointer on Uint8List {
  ffi.Pointer<ffi.Uint8> toUint8Pointer() {
    final ptr = malloc.allocate<ffi.Uint8>(ffi.sizeOf<ffi.Uint8>() * length);
    for (var i = 0; i < length; i++) {
      ptr.elementAt(i).value = this[i];
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
      ptr.elementAt(i).ref.x = this[i].x;
      ptr.elementAt(i).ref.y = this[i].y;
    }
    return ptr;
  }
}

Uint8List blankBytes() {
  return const Base64Codec()
      .decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
}
