import 'dart:io';
import 'dart:typed_data';

import 'package:open_scanner/domain/resource.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ResourceRepo {
  List<ResourceDomain> entities = [];

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
    final directory = await getApplicationDocumentsDirectory();

    for (var entity in entities) {
      final path = "${directory.path}/${entity.name}.png";
      final file = File(path);
      file.writeAsBytesSync(entity.image!, flush: true);
    }
  }

  Future<List<ResourceDomain>> loadResources() async {
    List<ResourceDomain> entities = [];

    final directory = await getApplicationDocumentsDirectory();
    final contents = directory.listSync();
    for (var content in contents) {
      if (content is !File) continue;
      if (extension(content.path) != ".png") continue;

      final entity = ResourceDomain();
      entity.image = content.readAsBytesSync();
      entity.name = basenameWithoutExtension(content.path);
      entities.add(entity);
    }

    return entities;
  }
}
