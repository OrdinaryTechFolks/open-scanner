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
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  initStateAsync() async {
    cameraController = await widget.vm.getCameraController();
    setState(() {});
  }

  @override
  void dispose() {
    if (cameraController != null) {
      widget.vm.disposeController(cameraController!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: Center(
        child: AspectRatio(
          aspectRatio: cameraController!.value.aspectRatio,
          child: CameraPreview(cameraController!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file = await widget.vm.takePicture(cameraController!);
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
  }
}
