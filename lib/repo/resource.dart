import 'dart:io';
import 'dart:typed_data';

import 'package:open_scanner/config/config.dart';
import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/pkg/query_builder.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> initResourcesFolder() async {
    final appDir = await getApplicationDocumentsDirectory();
    final newDir = Directory("${appDir.path}/.blob");
    await newDir.create();
  }

  Future<void> saveResources() async {
    final directory = await getApplicationDocumentsDirectory();
    const uuid = Uuid();

    for (var entity in entities) {
      final filepath = "${directory.path}/.blob/.${uuid.v4()}";
      final file = File(filepath);
      if (await file.exists()) return;

      file.writeAsBytesSync(entity.image!, flush: true);
      await openScannerDB.execute(
        "INSERT INTO resources(name, image_path) VALUES (?, ?)",
        arguments: [entity.name, filepath],
      );
    }
  }

  Future<(List<ResourceDomain>, int)> loadResources(
      int currID, String searchTerm) async {
    List<ResourceDomain> entities = [];

    final qb = QueryBuilder(
        "SELECT id, name, image_path, created_at FROM resources WHERE 1 = 1",
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
      entity.imagePath = result['image_path'] as String;

      final file = File(entity.imagePath);
      if (!await file.exists()) continue;
      entity.image = file.readAsBytesSync();

      entity.createdAt = DateTime.parse(result['created_at'] as String);
      entities.add(entity);
    }

    if (entities.length <= config.paginationLimit) {
      return (entities, -1);
    }

    final nextEntity = entities.removeLast();
    return (entities, nextEntity.id);
  }

  Future<void> deleteResource(int id) async {
    await openScannerDB
        .execute("DELETE FROM resources WHERE id = ?", arguments: [id]);
  }
}
