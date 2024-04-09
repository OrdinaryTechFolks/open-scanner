import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:open_scanner/domain/ratio.dart';
import 'package:open_scanner/pkg/navigator.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/ratio.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

const originalRatioID = -1;
const customRatioID = -2;

class ResourcesCreateEditScreen extends StatefulWidget {
  final CropToolRepo cropToolRepo;
  final OpenCVRepo openCVRepo;
  final ResourceRepo resourceRepo;
  final RatioRepo ratioRepo;

  Future<Either<Error, Uint8List>> getTransformedImage() async {
    final corners = cropToolRepo.tool.getCorners();
    final destImage = openCVRepo.transform(cropToolRepo.image, corners);

    final encodeRes = await destImage.getEncodedList();
    if (encodeRes.isLeft) return Left(encodeRes.left);

    return Right(encodeRes.right);
  }

  const ResourcesCreateEditScreen(
      this.cropToolRepo, this.openCVRepo, this.resourceRepo, this.ratioRepo,
      {super.key});

  @override
  ResourcesCreateEditScreenState createState() =>
      ResourcesCreateEditScreenState();
}

enum SubMenu {
  aspectRatio,
  size,
}

// A widget that displays the picture taken by the user.
class ResourcesCreateEditScreenState extends State<ResourcesCreateEditScreen> {
  Uint8List image = Uint8List(0);
  String name = "";

  final ValueNotifier<SubMenu?> subMenuNotifier = ValueNotifier(null);

  void setSubMenuNotifier(SubMenu subMenu) {
    subMenuNotifier.value = subMenuNotifier.value == subMenu ? null : subMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit the crop')),
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
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: subMenuNotifier,
        builder: (context, subMenu, child) {
          return BottomAppBar(
            height: subMenu != null ? 136 : 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (subMenu != null)
                  switch (subMenu) {
                    SubMenu.aspectRatio => FutureBuilder(
                        future: widget.ratioRepo.listRatios(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final ratio in snapshot.data!)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(ratio.name,
                                              style:
                                                  const TextStyle(fontSize: 8)),
                                          Text(ratio.toString(),
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    SubMenu.size => const Text("Size"),
                  },
                if (subMenu != null) const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setSubMenuNotifier(SubMenu.aspectRatio);
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Aspect Ratio", style: TextStyle(fontSize: 8)),
                          Text("Original", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () => showSaveDialog(context),
                      child: const Text("Save"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setSubMenuNotifier(SubMenu.size);
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Size", style: TextStyle(fontSize: 8)),
                          Text("200x300", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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
