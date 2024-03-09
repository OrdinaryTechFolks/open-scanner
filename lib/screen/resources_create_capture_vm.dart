import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class ResourcesCreateCaptureVM {
  final CropToolRepo cropToolRepo;

  ResourcesCreateCaptureVM(this.cropToolRepo);

  Future<CameraController> getCameraController() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    final controller = CameraController(camera, ResolutionPreset.ultraHigh);

    await controller.initialize();
    return controller;
  }

  disposeController(CameraController controller) {
    controller.dispose();
  }

  Future<XFile> takePicture(CameraController controller) async {
    await controller.setFocusMode(FocusMode.locked);
    await controller.setExposureMode(ExposureMode.locked);
    final imageFile = await controller.takePicture();
    await controller.setFocusMode(FocusMode.auto);
    await controller.setExposureMode(ExposureMode.auto);

    return imageFile;
  }

  Future<Error?> setSelectedImage(XFile file) async{
    final bytes = await file.readAsBytes();
    final img = await ImageDomain.fromEncodedList(bytes);
    if (img == null) return FlutterError("Decoded image returns null");

    cropToolRepo.selectedImage = img;
    return null;
  }
}
