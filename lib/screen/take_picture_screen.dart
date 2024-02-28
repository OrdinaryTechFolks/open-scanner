import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:bgm_frontend/domain/domain.image.dart';
import 'package:bgm_frontend/repo/opencv/repo.opencv.methods.dart';
import 'package:bgm_frontend/screen/display_picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.openCVRepo,
  });

  final CameraDescription camera;
  final OpenCVRepo openCVRepo;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<Either<ImageDomain, Error>>  getTransformedImage(ImageDomain src, List<Point<double>> srcCorners) async  {
    var tImg = widget.openCVRepo.transform(src, srcCorners);

    Completer<ui.Image?> decodeRes = Completer();
    ui.decodeImageFromPixels(tImg.data, tImg.size.width.toInt(), tImg.size.height.toInt(), ui.PixelFormat.rgba8888, (res) {
      decodeRes.complete(res);
    });
    var image = await decodeRes.future;
    if (image == null) return Right(FlutterError("Decoded image return null"));

    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return Right(FlutterError("Converted byte return null"));
    
    tImg.data = data.buffer.asUint8List();
    return Left(tImg); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Center(
                child: CameraPreview(
              _controller,
            ));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            await _controller.setFocusMode(FocusMode.locked);
            await _controller.setExposureMode(ExposureMode.locked);
            final imageFile = await _controller.takePicture();
            await _controller.setFocusMode(FocusMode.auto);
            await _controller.setExposureMode(ExposureMode.auto);
            if (!mounted) return;

            final image = await decodeImageFromList(await imageFile.readAsBytes());
            final imageData = (await image.toByteData())?.buffer.asUint8List();
            if (imageData == null) return;

            final srcImg = ImageDomain(ui.Size(image.width.toDouble(), image.height.toDouble()), 4, imageData);
            
            const double width = 360;
            const double height = 640;

            const List<Point<double>> srsCorners = [Point(0, 0+100), Point(width + 200, 0 + 100), Point(0 + 100, height + 100), Point(width + 100, height + 100)]; 
            final tRes = await getTransformedImage(srcImg, srsCorners);
            if (tRes.isRight) return print(tRes.right.toString());

            print("opencv version:${widget.openCVRepo.version()}");
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  image: tRes.left,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}