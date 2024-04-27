import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_scanner/pkg/format.dart';

class RatioDomain {
  final int id;
  final String name;
  late final Size size;

  late final Axis axis;
  late final double ratio;

  RatioDomain(this.id, this.name, Size size) {
    final (axis, ratio) = RatioDomain.getAxisAndRatio(size);
    this.axis = axis;
    this.ratio = ratio;

    if (max(size.width, size.height) < 100) {
      this.size = size;
      return;
    }

    final gcd = size.width.toInt().gcd(size.height.toInt());
    if (gcd > 1) {
      this.size = Size(size.width.toInt() / gcd, size.height.toInt() / gcd);
      return;
    }

    this.size = axis == Axis.horizontal ? Size(ratio, 1) : Size(1, ratio);
  }

  static (Axis, double) getAxisAndRatio(Size size) {
    final axis = size.width > size.height ? Axis.horizontal : Axis.vertical;
    final ratio = size.width > size.height
        ? size.width / size.height
        : size.height / size.width;

    return (axis, ratio);
  }

  Size transform(Size size) {
    return Size(
      axis == Axis.horizontal ? size.height * ratio : size.width,
      axis == Axis.vertical ? size.width * ratio : size.height,
    );
  }

  Size transformAxis() {
    return Size(
      axis == Axis.horizontal ? ratio : 1,
      axis == Axis.vertical ? ratio : 1,
    );
  }

  @override
  String toString() {
    return "${size.width.toStringAsFixedOpt(2)} : ${size.height.toStringAsFixedOpt(2)}";
  }
}
