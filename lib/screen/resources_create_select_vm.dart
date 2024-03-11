import 'dart:typed_data';
import 'dart:ui';

import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:either_dart/either.dart';

typedef InitDisposeFn = (void Function(), void Function());

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

  InitDisposeFn getCropToolListener(){
    final List<InitDisposeFn> initDisposeFns = [];
    
    for (var i = 0; i < cropToolRepo.entityNotifiers.length; i++) {
      fn() => resourceRepo.resetResource(i);
      initDisposeFns.add((
          () { cropToolRepo.entityNotifiers[i].addListener(fn); },
          () { cropToolRepo.entityNotifiers[i].removeListener(fn); },
      ));
    }

    return (
      () { for (var (initFn, _) in initDisposeFns) { initFn(); } },
      () { for (var (_, disposeFn) in initDisposeFns) { disposeFn(); } },
    );
  }
}
