//
//  Generated code. Do not modify.
//  source: open-scanner-be/v1/opencv.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.int? width,
    $core.int? height,
    $core.int? channels,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (channels != null) {
      $result.channels = channels;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Image._() : super();
  factory Image.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Image.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Image', package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'channels', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Image clone() => Image()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Image copyWith(void Function(Image) updates) => super.copyWith((message) => updates(message as Image)) as Image;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  Image createEmptyInstance() => create();
  static $pb.PbList<Image> createRepeated() => $pb.PbList<Image>();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get channels => $_getIZ(2);
  @$pb.TagNumber(3)
  set channels($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChannels() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannels() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getN(3);
  @$pb.TagNumber(4)
  set data($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasData() => $_has(3);
  @$pb.TagNumber(4)
  void clearData() => clearField(4);
}

class Point2f extends $pb.GeneratedMessage {
  factory Point2f({
    $core.double? x,
    $core.double? y,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    return $result;
  }
  Point2f._() : super();
  factory Point2f.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point2f.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point2f', package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point2f clone() => Point2f()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point2f copyWith(void Function(Point2f) updates) => super.copyWith((message) => updates(message as Point2f)) as Point2f;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point2f create() => Point2f._();
  Point2f createEmptyInstance() => create();
  static $pb.PbList<Point2f> createRepeated() => $pb.PbList<Point2f>();
  @$core.pragma('dart2js:noInline')
  static Point2f getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point2f>(create);
  static Point2f? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class Size2f extends $pb.GeneratedMessage {
  factory Size2f({
    $core.double? width,
    $core.double? height,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  Size2f._() : super();
  factory Size2f.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Size2f.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Size2f', package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Size2f clone() => Size2f()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Size2f copyWith(void Function(Size2f) updates) => super.copyWith((message) => updates(message as Size2f)) as Size2f;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Size2f create() => Size2f._();
  Size2f createEmptyInstance() => create();
  static $pb.PbList<Size2f> createRepeated() => $pb.PbList<Size2f>();
  @$core.pragma('dart2js:noInline')
  static Size2f getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Size2f>(create);
  static Size2f? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);
}

class WarpPerspectiveRequest extends $pb.GeneratedMessage {
  factory WarpPerspectiveRequest({
    Image? srcImage,
    $core.Iterable<Point2f>? srcCorners,
    Size2f? destSize,
  }) {
    final $result = create();
    if (srcImage != null) {
      $result.srcImage = srcImage;
    }
    if (srcCorners != null) {
      $result.srcCorners.addAll(srcCorners);
    }
    if (destSize != null) {
      $result.destSize = destSize;
    }
    return $result;
  }
  WarpPerspectiveRequest._() : super();
  factory WarpPerspectiveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WarpPerspectiveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WarpPerspectiveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'srcImage', protoName: 'srcImage', subBuilder: Image.create)
    ..pc<Point2f>(2, _omitFieldNames ? '' : 'srcCorners', $pb.PbFieldType.PM, protoName: 'srcCorners', subBuilder: Point2f.create)
    ..aOM<Size2f>(3, _omitFieldNames ? '' : 'destSize', protoName: 'destSize', subBuilder: Size2f.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WarpPerspectiveRequest clone() => WarpPerspectiveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WarpPerspectiveRequest copyWith(void Function(WarpPerspectiveRequest) updates) => super.copyWith((message) => updates(message as WarpPerspectiveRequest)) as WarpPerspectiveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WarpPerspectiveRequest create() => WarpPerspectiveRequest._();
  WarpPerspectiveRequest createEmptyInstance() => create();
  static $pb.PbList<WarpPerspectiveRequest> createRepeated() => $pb.PbList<WarpPerspectiveRequest>();
  @$core.pragma('dart2js:noInline')
  static WarpPerspectiveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WarpPerspectiveRequest>(create);
  static WarpPerspectiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Image get srcImage => $_getN(0);
  @$pb.TagNumber(1)
  set srcImage(Image v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSrcImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearSrcImage() => clearField(1);
  @$pb.TagNumber(1)
  Image ensureSrcImage() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Point2f> get srcCorners => $_getList(1);

  @$pb.TagNumber(3)
  Size2f get destSize => $_getN(2);
  @$pb.TagNumber(3)
  set destSize(Size2f v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDestSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestSize() => clearField(3);
  @$pb.TagNumber(3)
  Size2f ensureDestSize() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
