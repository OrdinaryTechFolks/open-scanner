import 'dart:async';
import 'dart:math';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/domain/ratio.dart';
import 'package:open_scanner/pkg/safe_catch.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';

const originalRatioID = -1;
const customRatioID = -2;
const forcedRatioID = -3;

class RatioRepo {
  final SQLiteClient openScannerDB;

  final codedRatios = {
    -101: RatioDomain(-101, "ISO A", Size(1, sqrt(2))),
    -102: RatioDomain(-102, "I-ISO A", Size(sqrt(2), 1)),
  };

  RatioRepo(this.openScannerDB);

  static RatioDomain convertDBToDomain(Map<String, Object?> result) {
    return RatioDomain(
      result['id'] as int,
      result['name'] as String,
      Size(
        result['horizontal'] as double,
        result['vertical'] as double,
      ),
    );
  }

  Future<Either<Error, List<RatioDomain>>> listRatios() async {
    List<RatioDomain> ratios = codedRatios.values.toList();

    final queryRes = await safeCatchFuture(() => openScannerDB.query(
          "SELECT id, name, horizontal, vertical FROM ratios",
        ));
    if (queryRes.isLeft) return Left(FlutterError(queryRes.left.toString()));

    for (var result in queryRes.right) {
      ratios.add(convertDBToDomain(result));
    }

    return Right(ratios);
  }

  Future<Either<Error, RatioDomain>> get(int id) async {
    RatioDomain? ratio;
    if (id < 0) {
      ratio = codedRatios[id];
      if (ratio == null) return Left(FlutterError("Ratio is not found"));
      return Right(ratio);
    }

    final queryRes = await safeCatchFuture(() => openScannerDB.query(
          "SELECT id, name, horizontal, vertical FROM ratios WHERE id = ? LIMIT 1",
          arguments: [id],
        ));
    if (queryRes.isLeft) return Left(FlutterError(queryRes.left.toString()));

    if (queryRes.right.isEmpty) return Left(FlutterError("Ratio is not found"));
    return Right(convertDBToDomain(queryRes.right[0]));
  }

  Future<Either<Error, RatioDomain>> add(String name, Size size) async {
    final queryRes = await safeCatchFuture(() => openScannerDB.query(
          "INSERT INTO ratios(name, horizontal, vertical) VALUES (?, ?, ?) RETURNING id",
          arguments: [name, size.width, size.height],
        ));
    if (queryRes.isLeft) return Left(FlutterError(queryRes.left.toString()));

    return Right(
      RatioDomain(queryRes.right[0]['id'] as int, name, size),
    );
  }

  Future<Error?> delete(int id) async {
    final execRes = await safeCatchFuture(() => openScannerDB.execute(
          "DELETE FROM ratios WHERE id = ?",
          arguments: [id],
        ));
    if (execRes.isLeft) return FlutterError(execRes.left.toString());

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
