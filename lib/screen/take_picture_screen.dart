import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

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
            final image = await _controller.takePicture();
            await _controller.setFocusMode(FocusMode.auto);
            await _controller.setExposureMode(ExposureMode.auto);

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class CropToolCorner extends StatefulWidget {
  final Point<double> position;
  final void Function(Point<double>) onUpdatePosition;

  const CropToolCorner(
      {super.key, required this.position, required this.onUpdatePosition});

  @override
  CropToolCornerState createState() => CropToolCornerState();
}

class CropToolCornerState extends State<CropToolCorner> {
  Point<double> position = const Point(0, 0);

  @override
  void initState() {
    super.initState();

    position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.y,
      left: widget.position.x,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position = Point(max(0, position.x + details.delta.dx),
                max(0, position.y + details.delta.dy));
          });

          widget.onUpdatePosition(position);
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(0, 255, 0, 0.5),
              border: Border.all(width: 1, color: Colors.red)),
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // CropToolCornerData
  List<Point<double>> cropToolCornerPosition = [
    const Point(0, 0),
    const Point(100, 0),
    const Point(0, 100),
    const Point(100, 100),
  ];

  void onUpdatePosition(int index, Point<double> updatedPosition) {
    setState(() {
      cropToolCornerPosition[index] = updatedPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: FileImage(File(widget.imagePath)),
              ),
            ),
          ),
          Stack(
            children: [
              ...cropToolCornerPosition
                  .asMap()
                  .entries
                  .map(
                    (entry) => CropToolCorner(
                      position: entry.value,
                      onUpdatePosition: (newPosition) =>
                          onUpdatePosition(entry.key, newPosition),
                    ),
                  )
                  .toList(),

              // ...cropToolCornerPosition.asMap().entries.map(
              //       (entry) => Positioned(
              //         top: entry.value.y,
              //         left: entry.value.x,
              //         child: GestureDetector(
              //           onPanUpdate: (details) => onUpdatePosition(
              //               entry.key,
              //               Point(max(0, entry.value.x + details.delta.dx),
              //                   max(0, entry.value.y + details.delta.dy))),
              //           child: Container(
              //             height: 100,
              //             width: 100,
              //             decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: const Color.fromRGBO(0, 255, 0, 0.5),
              //                 border: Border.all(width: 1, color: Colors.red)),
              //           ),
              //         ),
              //       ),
              //     ),
            ],
          ),
        ],
      ),
    );
  }
}
