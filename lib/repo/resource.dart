
import 'dart:typed_data';

import 'package:bgm_frontend/domain/resource.dart';

class ResourceRepo {
  List<ResourceDomain> entities = [];

  void resetResources(){
    entities = [];
  }

  void addResource(){
    entities.add(ResourceDomain());
  }

  void resetResource(int index){
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
}