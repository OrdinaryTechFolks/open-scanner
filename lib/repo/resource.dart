import 'dart:typed_data';

import 'package:open_scanner/config/config.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/pkg/query_builder.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';
import 'package:share_plus/share_plus.dart';

class ResourceRepo {
  final Config config;
  final SQLiteClient openScannerDB;
  List<ResourceDomain> entities = [];

  ResourceRepo(this.config, this.openScannerDB);

  void resetResources() {
    entities = [];
  }

  void addResource() {
    entities.add(ResourceDomain());
  }

  void resetResource(int index) {
    entities[index] = ResourceDomain();
  }

  void setResourceImage(int index, Uint8List image) {
    final entity = entities[index];
    if (entity.image != null) {
      return;
    }

    entities[index].image = image;
  }

  ResourceDomain getResource(int index) {
    return entities[index];
  }

  void setResourceName(int index, String name) {
    entities[index].name = name;
  }

  Future<void> saveResources() async {
    for (var entity in entities) {
      await openScannerDB.execute(
        "INSERT INTO resources(name, image_path, image_data) VALUES (?, '', ?)",
        arguments: [entity.name, entity.image!],
      );
    }
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
      final entity = ResourceDomain();
      entity.id = result['id'] as int;
      entity.name = result['name'] as String;
      entity.image = result['image_data'] as Uint8List;
      entity.createdAt = DateTime.parse(result['created_at'] as String);
      entities.add(entity);
    }

    if (entities.length <= config.paginationLimit) {
      return (entities, -1);
    }

    final nextEntity = entities.removeLast();
    return (entities, nextEntity.id);
  }

  Future<ShareResultStatus> exportResources(
      List<ResourceDomain> resources) async {
    final List<XFile> files = [];
    for (var res in resources) {
      if (res.image == null) continue;

      final file = XFile.fromData(res.image!,
          name: res.name, mimeType: 'image/png', lastModified: res.createdAt);
      files.add(file);
    }

    if (files.isEmpty) return ShareResultStatus.dismissed;

    final shareRes = await Share.shareXFiles(files);
    return shareRes.status;
  }

  Future<void> deleteResources(List<int> id) async {
    final placeholders = id.map((_) => "?").join(", ");
    await openScannerDB
        .execute("DELETE FROM resources WHERE id IN ($placeholders)", arguments: id);
  }
}
