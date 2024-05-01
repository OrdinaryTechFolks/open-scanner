//
//  Generated code. Do not modify.
//  source: open-scanner-be/v1/opencv.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'opencv.pb.dart' as $0;

export 'opencv.pb.dart';

@$pb.GrpcServiceName('v1.OpenCVService')
class OpenCVServiceClient extends $grpc.Client {
  static final _$warpPerspective = $grpc.ClientMethod<$0.WarpPerspectiveRequest, $0.Image>(
      '/v1.OpenCVService/WarpPerspective',
      ($0.WarpPerspectiveRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Image.fromBuffer(value));

  OpenCVServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Image> warpPerspective($0.WarpPerspectiveRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$warpPerspective, request, options: options);
  }
}

@$pb.GrpcServiceName('v1.OpenCVService')
abstract class OpenCVServiceBase extends $grpc.Service {
  $core.String get $name => 'v1.OpenCVService';

  OpenCVServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.WarpPerspectiveRequest, $0.Image>(
        'WarpPerspective',
        warpPerspective_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.WarpPerspectiveRequest.fromBuffer(value),
        ($0.Image value) => value.writeToBuffer()));
  }

  $async.Future<$0.Image> warpPerspective_Pre($grpc.ServiceCall call, $async.Future<$0.WarpPerspectiveRequest> request) async {
    return warpPerspective(call, await request);
  }

  $async.Future<$0.Image> warpPerspective($grpc.ServiceCall call, $0.WarpPerspectiveRequest request);
}
