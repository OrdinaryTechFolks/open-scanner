import 'dart:async';
import 'dart:math';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/domain/ratio.dart';

const originalRatioID = -1;
const customRatioID = -2;
const forcedRatioID = -3;

class RatioRepo {
  final codedRatios = {
    -101: RatioDomain(-101, "ISO A", Size(1, sqrt(2))),
    -102: RatioDomain(-102, "I-ISO A", Size(sqrt(2), 1)),
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
    final id = codedRatios.length + 1;
    codedRatios[id] = (RatioDomain(id, name, size));

    return Right(id);
  }

  Future<Error?> delete(int id) async {
    codedRatios.remove(id);
    return null;
  }

  RatioDomain getOriginal(Size size) {
    return RatioDomain(originalRatioID, "Original", size);
  }

  RatioDomain getCustom(Size size) {
    return RatioDomain(customRatioID, "Custom", size);
  }

  RatioDomain getForced() {
    return RatioDomain(forcedRatioID, "Forced", Size.zero);
  }
}
