import 'dart:io';
import 'dart:typed_data';

import 'package:open_scanner/domain/resource.dart';
import 'package:open_scanner/pkg/query_builder.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ResourceRepo {
  final SQLiteClient openScannerDB;
  List<ResourceDomain> entities = [];

  ResourceRepo(this.openScannerDB);  

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

  Future<List<ResourceDomain>> loadResources(String searchTerm) async {
    List<ResourceDomain> entities = [];

    final qb = QueryBuilder("SELECT id, name, image_path, created_at FROM resources", null);
    if (searchTerm != "") {
      qb.addQuery("WHERE name LIKE '%' || ? || '%'", [searchTerm]);
    }
    qb.addString("ORDER BY id DESC");

    final results = await openScannerDB.query(qb.getQuery(), arguments: qb.getArgs());

    for (var result in results){
      final entity = ResourceDomain(); 
      entity.id = result['id'] as int;
      entity.name = result['name'] as String;

      final filepath = result['image_path'] as String;
      final file = File(filepath);
      if (!await file.exists()) continue;
      entity.image = file.readAsBytesSync();

      entity.createdAt = DateTime.parse(result['created_at'] as String);
      entities.add(entity);
    }

    return entities;
  }
}
