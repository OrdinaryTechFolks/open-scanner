//
//  Generated code. Do not modify.
//  source: open-scanner-be/v1/opencv.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'channels', '3': 3, '4': 1, '5': 5, '10': 'channels'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIUCgV3aWR0aBgBIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAIgASgFUgZoZWlnaHQSGg'
    'oIY2hhbm5lbHMYAyABKAVSCGNoYW5uZWxzEhIKBGRhdGEYBCABKAxSBGRhdGE=');

@$core.Deprecated('Use point2fDescriptor instead')
const Point2f$json = {
  '1': 'Point2f',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `Point2f`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List point2fDescriptor = $convert.base64Decode(
    'CgdQb2ludDJmEgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeQ==');

@$core.Deprecated('Use size2fDescriptor instead')
const Size2f$json = {
  '1': 'Size2f',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 2, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 2, '10': 'height'},
  ],
};

/// Descriptor for `Size2f`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List size2fDescriptor = $convert.base64Decode(
    'CgZTaXplMmYSFAoFd2lkdGgYASABKAJSBXdpZHRoEhYKBmhlaWdodBgCIAEoAlIGaGVpZ2h0');

@$core.Deprecated('Use warpPerspectiveRequestDescriptor instead')
const WarpPerspectiveRequest$json = {
  '1': 'WarpPerspectiveRequest',
  '2': [
    {'1': 'srcImage', '3': 1, '4': 1, '5': 11, '6': '.v1.Image', '10': 'srcImage'},
    {'1': 'srcCorners', '3': 2, '4': 3, '5': 11, '6': '.v1.Point2f', '10': 'srcCorners'},
    {'1': 'destSize', '3': 3, '4': 1, '5': 11, '6': '.v1.Size2f', '10': 'destSize'},
  ],
};

/// Descriptor for `WarpPerspectiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List warpPerspectiveRequestDescriptor = $convert.base64Decode(
    'ChZXYXJwUGVyc3BlY3RpdmVSZXF1ZXN0EiUKCHNyY0ltYWdlGAEgASgLMgkudjEuSW1hZ2VSCH'
    'NyY0ltYWdlEisKCnNyY0Nvcm5lcnMYAiADKAsyCy52MS5Qb2ludDJmUgpzcmNDb3JuZXJzEiYK'
    'CGRlc3RTaXplGAMgASgLMgoudjEuU2l6ZTJmUghkZXN0U2l6ZQ==');

