import 'package:flutter/material.dart';

class RatioDomain {
  final int id;
  final String name;
  final Axis axis;
  final double ratio;

  RatioDomain(this.id, this.name, this.axis, this.ratio);

  static (Axis, double) getAxisAndRatio(Size size) {
    final axis = size.width > size.height ? Axis.horizontal : Axis.vertical;
    final ratio = size.width > size.height
        ? size.width / size.height
        : size.height / size.width;

    return (axis, ratio);
  }

  Size getSize(Size size) {
    return Size(
      axis == Axis.horizontal ? size.height * ratio : size.width,
      axis == Axis.vertical ? size.width * ratio : size.height,
    );
  }

  double getCrossAxisSize(Axis axis, double size) {
    if (this.axis == axis) return size / ratio;
    return size * ratio;
  }

  @override
  String toString() {
    final ratioString = ratio.toStringAsFixed(2);
    return axis == Axis.horizontal ? "$ratioString : 1" : "1 : $ratioString";
  }
}
