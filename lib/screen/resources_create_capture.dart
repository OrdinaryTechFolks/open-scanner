import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/pkg/safe_catch.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ResourcesCreateCaptureScreen extends StatefulWidget {
  final CropToolRepo cropToolRepo;

  Future<CameraController> getCameraController() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    final controller = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await controller.initialize();
    return controller;
  }

  disposeController(CameraController controller) {
    controller.dispose();
  }

  Future<XFile> takePicture(CameraController controller) async {
    await safeCatchFuture(() => controller.setFlashMode(FlashMode.off));
    await safeCatchFuture(() => controller.setFocusMode(FocusMode.locked));
    await safeCatchFuture(
        () => controller.setExposureMode(ExposureMode.locked));
    final imageFile = await controller.takePicture();
    await safeCatchFuture(() => controller.setFocusMode(FocusMode.auto));
    await safeCatchFuture(() => controller.setExposureMode(ExposureMode.auto));

    return imageFile;
  }

  Future<Error?> setSelectedImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final img = await ImageDomain.fromEncodedList(bytes);
    if (img == null) return FlutterError("Decoded image returns null");

    cropToolRepo.selectedImage = img;
    return null;
  }

  const ResourcesCreateCaptureScreen(this.cropToolRepo, {super.key});

  @override
  ResourcesCreateCaptureScreenState createState() =>
      ResourcesCreateCaptureScreenState();
}

class ResourcesCreateCaptureScreenState
    extends State<ResourcesCreateCaptureScreen> {
  late Future<CameraController> getCameraController =
      widget.getCameraController();

  @override
  void dispose() async {
    super.dispose();
    final cameraController = await getCameraController;
    widget.disposeController(cameraController);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCameraController,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final cameraController = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Take a picture')),
          body: Center(
            child: AspectRatio(
              aspectRatio: 1 / cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final file = await widget.takePicture(cameraController);
              final setRes = await widget.setSelectedImage(file);

              if (!context.mounted) return;
              if (setRes != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(setRes.toString())));
                return;
              }

              await Navigator.of(context).pushNamed("/resources/create/select");
            },
            child: const Icon(Icons.camera_alt),
          ),
        );
      },
    );
  }
}
