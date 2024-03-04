import 'dart:typed_data';

import 'package:bgm_frontend/repo/opencv.dart';
import 'package:bgm_frontend/repo/resources.dart';
import 'package:either_dart/either.dart';

class ResourcesCreateEditVM {
  final int index;
  final ResourcesRepo resourcesRepo;
  final OpenCVRepo openCVRepo;

  ResourcesCreateEditVM(this.index, this.resourcesRepo, this.openCVRepo);

  Future<Either<Error, Uint8List>> getTransformedImage() async {
    final corners = resourcesRepo.cropTools[index].cornerPositions; 
    final destImage = openCVRepo.transform(resourcesRepo.selectedImage, corners);
    return destImage.getEncodedList();
  }
}
