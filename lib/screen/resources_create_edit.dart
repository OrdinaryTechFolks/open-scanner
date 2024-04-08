import 'dart:async';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:open_scanner/pkg/navigator.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

class ResourcesCreateEditScreen extends StatefulWidget {
  final CropToolRepo cropToolRepo;
  final OpenCVRepo openCVRepo;
  final ResourceRepo resourceRepo;

  Future<Either<Error, Uint8List>> getTransformedImage() async {
    final corners = cropToolRepo.tool.getCorners();
    final destImage = openCVRepo.transform(cropToolRepo.image, corners);

    final encodeRes = await destImage.getEncodedList();
    if (encodeRes.isLeft) return Left(encodeRes.left);

    return Right(encodeRes.right);
  }

  const ResourcesCreateEditScreen(
      this.cropToolRepo, this.openCVRepo, this.resourceRepo,
      {super.key});

  @override
  ResourcesCreateEditScreenState createState() =>
      ResourcesCreateEditScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateEditScreenState extends State<ResourcesCreateEditScreen> {
  Uint8List image = Uint8List(0);
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit the resource')),
      body: FutureBuilder(
          future: widget.getTransformedImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return const CircularProgressIndicator();
            }

            if (snapshot.data!.isLeft) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(snapshot.data!.left.toString())));
              return Container();
            }

            image = snapshot.data!.right;
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: MemoryImage(image),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => showSaveDialog(context),
                  icon: const Icon(Icons.save),
                )
              ],
            )),
      ),
    );
  }

  Future<void> showSaveDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Save resource"),
          content: TextField(
            onChanged: (value) => name = value,
            decoration: const InputDecoration(
              label: Text("Name"),
              border: OutlineInputBorder(),
              hintText: 'Enter your document name',
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () async {
                await widget.resourceRepo.saveResources(name, image);

                if (!context.mounted) return;
                Navigator.of(context).pop();

                return showCropAnotherDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showCropAnotherDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          content: const Text("Crop another resource?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                widget.cropToolRepo.addTool(const Offset(300, 300));
                await Navigator.of(context)
                    .popUntilAndReplace("/resources/create/crop");
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () async {
                widget.cropToolRepo.reset();
                await Navigator.of(context).popUntilAndReplace("/");
              },
            ),
          ],
        );
      },
    );
  }
}
