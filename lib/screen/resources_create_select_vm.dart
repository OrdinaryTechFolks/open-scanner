import 'dart:typed_data';
import 'dart:ui';

import 'package:bgm_frontend/domain/crop_tool.dart';
import 'package:bgm_frontend/repo/resources.dart';
import 'package:either_dart/either.dart';

class ResourcesCreateSelectVM {
  late ResourcesRepo resourcesRepo;

  ResourcesCreateSelectVM(this.resourcesRepo);

  addCropTool(Offset delta) {
    return resourcesRepo.cropTools.add(CropToolDomain(delta));
  }

  Future<Either<Error, Uint8List>> getSelectedImage() async {
    return await resourcesRepo.selectedImage.getEncodedList();
  }

  int getCropToolLength() {
    return resourcesRepo.cropTools.length;
  }
}
