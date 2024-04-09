import 'package:flutter/material.dart';

class RatioDomain {
  final int id;
  final String name;
  final Axis axis;
  final double ratio;

  RatioDomain(this.id, this.name, this.axis, this.ratio);

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
