import 'dart:ffi' as ffi;
import 'dart:io';
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