import 'package:open_scanner/component/crop_tool.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/pkg/init_dispose.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

class ResourcesCreateSelectScreen extends StatefulWidget {
  final CropToolRepo cropToolRepo;
  final ResourceRepo resourceRepo;

  void resetCropTool() {
    cropToolRepo.resetCropTools();
    resourceRepo.resetResources();
    
    cropToolRepo.addCropTool(const Offset(300, 300));
    resourceRepo.addResource();
  }

  ImageDomain getSelectedImage() {
    return cropToolRepo.selectedImage;
  }

  int getCropToolLength() {
    return cropToolRepo.entities.length;
  }

  InitDisposeFn getCropToolListener(){
    final List<InitDisposeFn> initDisposeFns = [];
    
    for (var i = 0; i < cropToolRepo.entityNotifiers.length; i++) {
      fn() => resourceRepo.resetResource(i);
      initDisposeFns.add((
          () { cropToolRepo.entityNotifiers[i].addListener(fn); },
          () { cropToolRepo.entityNotifiers[i].removeListener(fn); },
      ));
    }

    return (
      () { for (var (initFn, _) in initDisposeFns) { initFn(); } },
      () { for (var (_, disposeFn) in initDisposeFns) { disposeFn(); } },
    );
  }

  ResourcesCreateSelectScreen(this.cropToolRepo, this.resourceRepo, {super.key}){
    resetCropTool();
  }

  @override
  ResourcesCreateSelectScreenState createState() =>
      ResourcesCreateSelectScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateSelectScreenState
    extends State<ResourcesCreateSelectScreen> {
  late InitDisposeFn cropToolListener = widget.getCropToolListener();
  late final image = widget.getSelectedImage(); 

  @override
  void initState() {
    super.initState();
    cropToolListener.$1();
  }

  @override
  void dispose() {
    cropToolListener.$2();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop the image')),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.01,
        maxScale: 100,
        boundaryMargin: const EdgeInsets.all(200),
        child: Stack(
          children: [
            FutureBuilder(
                future: image.getEncodedList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data!.isLeft) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(snapshot.data!.left.toString())));
                    return Container();
                  }

                  return Container(
                    width: image.size.width,
                    height: image.size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.none,
                        image: MemoryImage(snapshot.data!.right),
                      ),
                    ),
                  );
                }),
            // Container(width: 100, height: 100, color: Colors.red),
            for (var i = 0; i < widget.getCropToolLength(); i++)
              SizedBox(width: image.size.width, height: image.size.height, child: CropTool(i, widget.cropToolRepo))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed(
                          "/resources/create/{id#int}/edit",
                          arguments: {"id": 0});
                    },
                    icon: const Icon(Icons.forward))
              ],
            )),
      ),
    );
  }
}
