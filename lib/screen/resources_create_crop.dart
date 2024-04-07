import 'package:open_scanner/component/crop_tool.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

class ResourcesCreateCropScreen extends StatefulWidget {
  final CropToolRepo cropToolRepo;
  final ResourceRepo resourceRepo;

  void resetCropTool() {
    resourceRepo.resetResources();
    
    cropToolRepo.addTool(const Offset(300, 300));
    resourceRepo.addResource();
  }

  ImageDomain getSelectedImage() {
    return cropToolRepo.image;
  }

  ResourcesCreateCropScreen(this.cropToolRepo, this.resourceRepo, {super.key}){
    resetCropTool();
  }

  @override
  ResourcesCreateCropScreenState createState() =>
      ResourcesCreateCropScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateCropScreenState
    extends State<ResourcesCreateCropScreen> {
  late final image = widget.getSelectedImage(); 

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
            SizedBox(width: image.size.width, height: image.size.height, child: CropTool(widget.cropToolRepo))
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
