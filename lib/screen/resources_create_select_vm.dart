import 'dart:typed_data';
import 'dart:ui';

import 'package:bgm_frontend/repo/crop_tool.dart';
import 'package:bgm_frontend/repo/resource.dart';
import 'package:either_dart/either.dart';

class ResourcesCreateSelectVM {
  final CropToolRepo cropToolRepo;
  final ResourceRepo resourceRepo;

  const ResourcesCreateSelectVM(this.cropToolRepo, this.resourceRepo);

  void resetCropTool() {
    cropToolRepo.resetCropTools();
    resourceRepo.resetResources();
    
    cropToolRepo.addCropTool(const Offset(300, 300));
    resourceRepo.addResource();
  }

  Future<Either<Error, Uint8List>> getSelectedImage() async {
    return await cropToolRepo.selectedImage.getEncodedList();
  }

  int getCropToolLength() {
    return cropToolRepo.entities.length;
  }
}
