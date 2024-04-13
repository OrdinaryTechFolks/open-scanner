import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/domain/ratio.dart';
import 'package:open_scanner/hook/use_future.dart';
import 'package:open_scanner/pkg/navigator.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/ratio.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

const originalRatioID = -1;
const customRatioID = -2;
const forcedRatioID = -3;

enum SubMenu {
  aspectRatio,
  size,
}

// A widget that displays the picture taken by the user.
class ResourcesCreateEditScreen extends StatelessWidget {
  final CropToolRepo cropToolRepo;
  final OpenCVRepo openCVRepo;
  final ResourceRepo resourceRepo;
  final RatioRepo ratioRepo;

  late final futureGTI = UseFuture(getTransformedImage);
  late final futureLR =
      UseFuture((void _) async => await ratioRepo.listRatios());
  final ValueNotifier<String> name = ValueNotifier("");
  final ValueNotifier<SubMenu?> subMenuNotifier = ValueNotifier(null);

  late final RatioDomain originalRatio;
  late final ValueNotifier<RatioDomain> customRatio;
  late final RatioDomain forcedRatio;

  late final ValueNotifier<RatioDomain> selectedRatio;

  late final ValueNotifier<Size> inputtedSize;

  ResourcesCreateEditScreen(
      this.cropToolRepo, this.openCVRepo, this.resourceRepo, this.ratioRepo,
      {super.key}) {
    initAsync();
  }

  initAsync() async {
    await futureGTI.execute(null);
    await futureLR.execute(null);

    final encodedImage = futureGTI.snapshot.value.result;
    final (axis, ratio) = RatioDomain.getAxisAndRatio(encodedImage.size);
    originalRatio = RatioDomain(originalRatioID, "Original", axis, ratio);
    customRatio = ValueNotifier(RatioDomain(customRatioID, "Custom", axis, ratio));
    forcedRatio = RatioDomain(forcedRatioID, "Forced", Axis.horizontal, 0);

    selectedRatio = ValueNotifier(originalRatio);
    inputtedSize = ValueNotifier(encodedImage.size);

    selectedRatio.addListener(() {
      if (selectedRatio.value.id == forcedRatioID) return;
      inputtedSize.value = selectedRatio.value.getSize(encodedImage.size);
    });

    inputtedSize.addListener(() async {
      await futureGTI.execute(inputtedSize.value);
    });
  }

  Future<Either<Error, EncodedImageDomain>> getTransformedImage(
      Size? preferredSize) async {

    final corners = cropToolRepo.tool.getCorners();
    final destImage = openCVRepo.transform(cropToolRepo.image, corners, preferredSize);

    return getEncodedImageDomain(destImage);
  }

  void setSubMenuNotifier(SubMenu subMenu) {
    subMenuNotifier.value = subMenuNotifier.value == subMenu ? null : subMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit the crop')),
      body: ValueListenableBuilder(
        valueListenable: futureGTI.snapshot,
        builder: (context, snapshot, child) {
          if (snapshot.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(snapshot.error!.toString())));
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: MemoryImage(snapshot.result.data),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: subMenuNotifier,
        builder: (context, subMenu, child) {
          return BottomAppBar(
            height: subMenu != null ? 136 : 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (subMenu != null) getSubMenuWidget(subMenu),
                if (subMenu != null) const Divider(),
                getMenuWidget(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Row getMenuWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OutlinedButton(
          onPressed: () {
            // TODO: show toast and disable when ratio is forced
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
    );
  }

  Widget getSubMenuWidget(SubMenu subMenu) {
    return switch (subMenu) {
      SubMenu.aspectRatio => ValueListenableBuilder(
          valueListenable: futureLR.snapshot,
          builder: (context, snapshot, child) {
            if (snapshot.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  getRatioItemWidget(originalRatio),
                  for (final ratio in snapshot.result) getRatioItemWidget(ratio),
                  getRatioItemWidget(customRatio.value),
                ],
              ),
            );
          },
        ),
      SubMenu.size => const Text("Size"),
    };
  }

  Container getRatioItemWidget(RatioDomain ratio) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {
          // TODO: show custom ratio popup
          selectedRatio.value = ratio;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(ratio.name, style: const TextStyle(fontSize: 8)),
            Text(ratio.toString(), style: const TextStyle(fontSize: 12)),
          ],
        ),
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
            onChanged: (value) => name.value = value,
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
                await resourceRepo.saveResources(
                    name.value, futureGTI.snapshot.value.result.data);

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
                cropToolRepo.addTool(const Offset(300, 300));
                await Navigator.of(context)
                    .popUntilAndReplace("/resources/create/crop");
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () async {
                cropToolRepo.reset();
                await Navigator.of(context).popUntilAndReplace("/");
              },
            ),
          ],
        );
      },
    );
  }
}
