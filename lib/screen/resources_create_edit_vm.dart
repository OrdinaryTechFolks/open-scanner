import 'dart:typed_data';

import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:either_dart/either.dart';

class ResourcesCreateEditVM {
  final int index;
  final CropToolRepo cropToolRepo;
  final OpenCVRepo openCVRepo;
  final ResourceRepo resourceRepo;

  ResourcesCreateEditVM(
      this.index, this.cropToolRepo, this.openCVRepo, this.resourceRepo);

  Future<Either<Error, Uint8List>> getTransformedImage() async {
    final resource = resourceRepo.getResource(index);
    if (resource.image != null) {
      return Right(resource.image!);
    }

    final corners = cropToolRepo.getCropToolCorners(index);
    final destImage = openCVRepo.transform(cropToolRepo.selectedImage, corners);

    final encodeRes = await destImage.getEncodedList();
    if (encodeRes.isLeft){
      return Left(encodeRes.left);
    }

    resourceRepo.setResourceImage(index, encodeRes.right);
    return Right(encodeRes.right);
  }

  int getNextIndex() {
    final nextID = index + 1;
    if (index >= cropToolRepo.entities.length) {
      return -1;
    }
    return nextID;
  }
}
