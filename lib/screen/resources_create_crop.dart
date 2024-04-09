import 'package:measure_size/measure_size.dart';
import 'package:open_scanner/component/crop_tool.dart';
import 'package:open_scanner/component/crop_tool_plane_painter.dart';
import 'package:open_scanner/domain/image.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

class ResourcesCreateCropScreen extends StatefulWidget {
  final CropToolRepo cropToolRepo;
  final ResourceRepo resourceRepo;

  ImageDomain getSelectedImage() {
    return cropToolRepo.image;
  }

  const ResourcesCreateCropScreen(this.cropToolRepo, this.resourceRepo,
      {super.key});

  @override
  ResourcesCreateCropScreenState createState() =>
      ResourcesCreateCropScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateCropScreenState extends State<ResourcesCreateCropScreen> {
  late final image = widget.getSelectedImage();
  TransformationController controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop the image')),
      body: MeasureSize(
        onChange: (size) {
          double scaleWidth = size.width / image.size.width;
          double scaleHeight = size.height / image.size.height;
          double targetScale =
              scaleWidth < scaleHeight ? scaleWidth : scaleHeight;

          controller.value = Matrix4.identity() * targetScale;

          if (scaleWidth < scaleHeight) {
            final viewHeight = size.height / targetScale;
            final diffHeight = viewHeight - image.size.height;
            controller.value.setTranslationRaw(0, diffHeight / 4, 0);
          } else {
            final viewWidth = size.width / targetScale;
            final diffWidth = viewWidth - image.size.width;
            controller.value.setTranslationRaw(diffWidth / 4, 0, 0);
          }
        },
        child: InteractiveViewer(
          transformationController: controller,
          constrained: false,
          minScale: 0.1,
          maxScale: 10,
          boundaryMargin: const EdgeInsets.all(80),
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
              for (final cropTool in widget.cropToolRepo.pastTools)
                CustomPaint(
                  painter: CropToolPlanePainter(cropTool),
                  child: Container(),
                ),
              SizedBox(
                  width: image.size.width,
                  height: image.size.height,
                  child: CropTool(widget.cropToolRepo))
            ],
          ),
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
                      await Navigator.of(context)
                          .pushNamed("/resources/create/edit");
                    },
                    icon: const Icon(Icons.forward))
              ],
            )),
      ),
    );
  }
}
