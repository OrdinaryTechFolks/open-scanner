import 'dart:math';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/domain/ratio.dart';

class RatioRepo {
  final ratios = [
    RatioDomain(1, "ISO A", Axis.vertical, sqrt(2)),
    RatioDomain(2, "I-ISO A", Axis.horizontal, sqrt(2)),
  ];

  RatioRepo();

  Future<Either<Error, List<RatioDomain>>> listRatios() async {
    return Right(ratios);
  }

  void add(String name, Size size) async {
    final axis = size.width > size.height ? Axis.horizontal : Axis.vertical;
    final ratio = size.width > size.height
        ? size.width / size.height
        : size.height / size.width;

    ratios.add(
      RatioDomain(ratios.length, name, axis, ratio),
    );
  }
}
