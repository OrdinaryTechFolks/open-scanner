import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/domain/ratio.dart';
import 'package:open_scanner/hook/use_future.dart';
import 'package:open_scanner/pkg/error.dart';
import 'package:open_scanner/pkg/format.dart';
import 'package:open_scanner/pkg/navigator.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/ratio.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

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

  late final ValueNotifier<RatioDomain> selectedRatio =
      ValueNotifier(ratioRepo.getOriginal(Size.zero));
  late final ValueNotifier<Size> inputtedSize = ValueNotifier(Size.zero);

  ResourcesCreateEditScreen(
      this.cropToolRepo, this.openCVRepo, this.resourceRepo, this.ratioRepo,
      {super.key}) {
    initAsync();
  }

  initAsync() async {
    await futureGTI.execute(null);
    await futureLR.execute(null);

    final encodedImage = futureGTI.snapshot.value.result;
    originalRatio = ratioRepo.getOriginal(encodedImage.size);
    customRatio = ValueNotifier(ratioRepo.getCustom(encodedImage.size));
    forcedRatio = ratioRepo.getForced();

    inputtedSize.value = encodedImage.size;

    selectedRatio.addListener(() async {
      if (selectedRatio.value.id == forcedRatioID) return;
      inputtedSize.value = selectedRatio.value.transform(encodedImage.size);
    });

    inputtedSize.addListener(() async {
      await futureGTI.execute(inputtedSize.value);
    });
  }

  Future<Either<Error, RatioDomain>> getRatio(int ratioID) async {
    if (ratioID == originalRatioID) return Right(originalRatio);
    if (ratioID == customRatioID) return Right(customRatio.value);

    return ratioRepo.get(ratioID);
  }

  Future<Either<Error, EncodedImageDomain>> getTransformedImage(
      Size? preferredSize) async {
    final corners = cropToolRepo.tool.getCorners();
    final destImage =
        await openCVRepo.transform(cropToolRepo.image, corners, preferredSize);

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
        valueListenable: futureGTI.snapshot,
        builder: (context, value, child) {
          if (value.loading) {
            return const SizedBox.shrink();
          }

          return ValueListenableBuilder(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Aspect Ratio", style: TextStyle(fontSize: 8)),
              ValueListenableBuilder(
                valueListenable: selectedRatio,
                builder: (context, value, child) =>
                    Text(value.name, style: const TextStyle(fontSize: 12)),
              ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Size", style: TextStyle(fontSize: 8)),
              ValueListenableBuilder(
                valueListenable: inputtedSize,
                builder: (context, value, child) => Text(value.toStringUI(),
                    style: const TextStyle(fontSize: 12)),
              ),
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
                  getRatioItemWidget(context, originalRatio),
                  for (final ratio in snapshot.result)
                    getRatioItemWidget(context, ratio),
                  ValueListenableBuilder(
                    valueListenable: customRatio,
                    builder: (context, value, child) =>
                        getRatioItemWidget(context, value),
                  ),
                ],
              ),
            );
          },
        ),
      SubMenu.size => const Text("Size"),
    };
  }

  Container getRatioItemWidget(BuildContext context, RatioDomain ratio) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onLongPress: () {
          if (ratio.id <= 0) {
            return ErrorPackage.showSnackBar(
              FlutterError("Only saved custom ratio can be deleted"),
            );
          }
          getDeleteSavedRatioDialog(context, ratio);
        },
        onPressed: () async {
          if (ratio.id == customRatioID) {
            final selectedCustomRatio =
                await showCustomRatioBottomSheet(context);
            if (selectedCustomRatio != null) {
              selectedRatio.value = selectedCustomRatio;
            }
            return;
          }
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

  Future<dynamic> getDeleteSavedRatioDialog(
      BuildContext context, RatioDomain ratio) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Delete Ratio"),
          content: Text("Are you sure you want to delete ${ratio.name}?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () async {
                await ratioRepo.delete(ratio.id);
                await futureLR.execute(null);
                if (ratio == selectedRatio.value) {
                  selectedRatio.value = originalRatio;
                }

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<RatioDomain?> showCustomRatioBottomSheet(BuildContext context) async {
    final isSaveNotifier = ValueNotifier(false);

    final widthTextCtrl = TextEditingController(
        text: customRatio.value.size.width.toStringAsFixedOpt(2));
    final heightTextCtrl = TextEditingController(
        text: customRatio.value.size.height.toStringAsFixedOpt(2));
    var name = "";

    return showModalBottomSheet<RatioDomain>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ValueListenableBuilder(
            valueListenable: isSaveNotifier,
            builder: (context, isSave, child) {
              return Container(
                padding: EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 16 + MediaQuery.of(context).viewInsets.bottom),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 12,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Custom Ratio',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextField(
                      onChanged: (value) {},
                      controller: widthTextCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Horizontal"),
                        border: OutlineInputBorder(),
                        hintText: 'Enter a number',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {},
                      controller: heightTextCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Vertical"),
                        border: OutlineInputBorder(),
                        hintText: 'Enter a number',
                      ),
                    ),
                    SwitchListTile(
                      title: const Text("Save the ratio?"),
                      secondary: const Icon(Icons.save),
                      value: isSave,
                      onChanged: (value) {
                        isSaveNotifier.value = value;
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).dividerColor, width: 1),
                        borderRadius: const OutlineInputBorder().borderRadius,
                      ),
                    ),
                    if (isSaveNotifier.value) ...[
                      TextField(
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: const InputDecoration(
                          label: Text("Name"),
                          border: OutlineInputBorder(),
                          hintText: 'Enter a ratio name',
                        ),
                      ),
                    ],
                    Align(
                      alignment: Alignment.topRight,
                      child: FilledButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: isSaveNotifier.value
                            ? const Text("Save and Apply")
                            : const Text("Apply"),
                        onPressed: () async {
                          if (isSaveNotifier.value) {
                            final addRes = await ratioRepo.add(
                              name,
                              Size(
                                double.parse(widthTextCtrl.text),
                                double.parse(heightTextCtrl.text),
                              ),
                            );

                            if (addRes.isLeft) {
                              return ErrorPackage.showSnackBar(addRes.left);
                            }

                            await futureLR.execute(null);

                            if (!context.mounted) return;
                            Navigator.of(context).pop(addRes.right);
                          } else {
                            customRatio.value = ratioRepo.getCustom(
                              Size(
                                double.parse(widthTextCtrl.text),
                                double.parse(heightTextCtrl.text),
                              ),
                            );
                            Navigator.of(context).pop(customRatio.value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> showSaveDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
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
