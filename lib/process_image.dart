import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

// C function signatures
typedef _CVersionFunc = ffi.Pointer<Utf8> Function();
typedef _CProcessImageFunc = ffi.Void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Dart function signatures
typedef _VersionFunc = ffi.Pointer<Utf8> Function();
typedef _ProcessImageFunc = void Function(ffi.Pointer<Utf8>, ffi.Pointer<Utf8>);

// Getting a library that holds needed symbols
ffi.DynamicLibrary _lib = Platform.isAndroid
  ? ffi.DynamicLibrary.open('libOpenCV_ffi.so')
  : ffi.DynamicLibrary.process();

// Looking for the functions
final _VersionFunc _version = _lib
  .lookupFunction<_CVersionFunc, _VersionFunc>('version');
final _ProcessImageFunc _processImage = _lib
  .lookup<ffi.NativeFunction<_CProcessImageFunc>>('process_image')
  .asFunction();

String opencvVersion() {
  return _version().toDartString();
}

void processImage(String inputPath, String outputPath) {
  _processImage(inputPath.toNativeUtf8(), outputPath.toNativeUtf8());
}

final class Image extends ffi.Struct {
  @ffi.Int32()
  external int width;

  @ffi.Int32()
  external int height;

  external ffi.Pointer<ffi.Uint8> data;

  Uint8List getData() {
    return data.asTypedList(width * height);
  } 
}

typedef _TransformFunc = Image Function(ffi.Pointer<Image>);
final _TransformFunc _transform = _lib.lookupFunction<_TransformFunc, _TransformFunc>('transform');

Image transform(int width, int height, Uint8List data) {
  ffi.Pointer<Image> src = calloc<Image>();
  src.ref.width = width;
  src.ref.height = height;
  src.ref.data = data.toUint8Pointer();

  return _transform(src);
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