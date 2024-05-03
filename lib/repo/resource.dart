import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_scanner/config/config.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/pkg/query_builder.dart';
import 'package:open_scanner/pkg/safe_catch.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';
import 'package:file_saver/file_saver.dart';

class ResourceRepo {
  final Config config;
  final SQLiteClient openScannerDB;

  ResourceRepo(this.config, this.openScannerDB);

  Future<void> saveResources(String name, Uint8List image) async {
    await openScannerDB.execute(
      "INSERT INTO resources(name, image_path, image_data) VALUES (?, '', ?)",
      arguments: [name, image],
    );
  }

  Future<(List<ResourceDomain>, int)> loadResources(
      int currID, String searchTerm) async {
    List<ResourceDomain> entities = [];

    final qb = QueryBuilder(
        "SELECT id, name, image_data, created_at FROM resources WHERE 1 = 1",
        null);

    if (currID != 0) {
      qb.addQuery("AND id <= ?", [currID]);
    }

    if (searchTerm != "") {
      qb.addQuery("AND name LIKE '%' || ? || '%'", [searchTerm]);
    }
    qb.addQuery("ORDER BY id DESC LIMIT ?", [config.paginationLimit + 1]);

    final results =
        await openScannerDB.query(qb.getQuery(), arguments: qb.getArgs());

    for (var result in results) {
      entities.add(ResourceDomain(
        result['id'] as int,
        result['name'] as String,
        DateTime.parse(result['created_at'] as String),
        result['image_data'] as Uint8List,
      ));
    }

    if (entities.length <= config.paginationLimit) {
      return (entities, -1);
    }

    final nextEntity = entities.removeLast();
    return (entities, nextEntity.id);
  }

  Future<Error?> downloadAll(List<ResourceDomain> resources) async {
    for (var res in resources) {
      final saveRes = await safeCatchFuture(() => FileSaver.instance.saveFile(
        name: "${res.name}_${res.createdAt.millisecondsSinceEpoch}",
        bytes: res.image,
        ext: "png",
        mimeType: MimeType.png,
      ));
      
      if (saveRes.isLeft) {
        return FlutterError(saveRes.left.toString());
      }
    }

    return null;
  }

  Future<int> deleteResources(List<int> ids) async {
    final placeholders = ids.map((_) => "?").join(", ");
    await openScannerDB.execute(
      "DELETE FROM resources WHERE id IN ($placeholders)",
      arguments: ids,
    );

    return ids.length;
  }
}
