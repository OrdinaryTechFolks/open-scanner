import 'dart:math';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/domain/ratio.dart';

const originalRatioID = -1;
const customRatioID = -2;
const forcedRatioID = -3;

class RatioRepo {
  final codedRatios = {
    -101: RatioDomain(-101, "ISO A", Axis.vertical, sqrt(2)),
    -102: RatioDomain(-102, "I-ISO A", Axis.horizontal, sqrt(2)),
  };

  RatioRepo();

  Future<Either<Error, List<RatioDomain>>> listRatios() async {
    return Right(codedRatios.values.toList());
  }

  Future<Either<Error, RatioDomain>> get(int id) async {
    final ratio = codedRatios[id];
    if (ratio == null) return Left(FlutterError("Ratio is not found"));
    return Right(ratio);
  }

  Future<Either<Error, int>> add(String name, Size size) async {
    final (axis, ratio) = RatioDomain.getAxisAndRatio(size);
    final id = codedRatios.length + 1;
    codedRatios[id] = (RatioDomain(id, name, axis, ratio));

    return Right(id);
  }

  Future<Error?> delete(int id) async {
    codedRatios.remove(id);
    return null;
  }

  RatioDomain getOriginal(Axis axis, double ratio) {
    return RatioDomain(originalRatioID, "Original", axis, ratio);
  }

  RatioDomain getCustom(Axis axis, double ratio) {
    return RatioDomain(customRatioID, "Custom", axis, ratio);
  }

  RatioDomain getForced() {
    return RatioDomain(forcedRatioID, "Forced", Axis.horizontal, 0);
  }
}
