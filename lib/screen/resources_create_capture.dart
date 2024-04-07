import 'package:open_scanner/screen/resources_create_capture_vm.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ResourcesCreateCaptureScreen extends StatefulWidget {
  const ResourcesCreateCaptureScreen({super.key, required this.vm});

  final ResourcesCreateCaptureVM vm;

  @override
  ResourcesCreateCaptureScreenState createState() =>
      ResourcesCreateCaptureScreenState();
}

class ResourcesCreateCaptureScreenState
    extends State<ResourcesCreateCaptureScreen> {
  late Future<CameraController> getCameraController = widget.vm.getCameraController();

  @override
  void dispose() async {
    super.dispose();
    final cameraController = await getCameraController;
    widget.vm.disposeController(cameraController);
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
              final file = await widget.vm.takePicture(cameraController);
              final setRes = await widget.vm.setSelectedImage(file);

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
