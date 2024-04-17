import 'dart:math';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/domain/ratio.dart';

class RatioRepo {
  final ratios = {
    1: RatioDomain(1, "ISO A", Axis.vertical, sqrt(2)),
    2: RatioDomain(2, "I-ISO A", Axis.horizontal, sqrt(2)),
  };

  RatioRepo();

  Future<Either<Error, List<RatioDomain>>> listRatios() async {
    return Right(ratios.values.toList());
  }

  Future<Either<Error, RatioDomain>> get(int id) async {
    final ratio = ratios[id];
    if (ratio == null) return Left(FlutterError("Ratio is not found"));
    return Right(ratio);
  }

  Future<Either<Error, int>> add(String name, Size size) async {
    final (axis, ratio) = RatioDomain.getAxisAndRatio(size);
    final id = ratios.length + 1;
    ratios[id] = (RatioDomain(id, name, axis, ratio));

    return Right(id);
  }
}
