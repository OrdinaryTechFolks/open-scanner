import 'package:open_scanner/component/crop_tool.dart';
import 'package:open_scanner/component/crop_tool_vm.dart';
import 'package:open_scanner/screen/resources_create_select_vm.dart';
import 'package:flutter/material.dart';

class ResourcesCreateSelectScreen extends StatefulWidget {
  final ResourcesCreateSelectVM vm;

  ResourcesCreateSelectScreen({super.key, required this.vm}){
    vm.resetCropTool();
  }

  @override
  ResourcesCreateSelectScreenState createState() =>
      ResourcesCreateSelectScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateSelectScreenState
    extends State<ResourcesCreateSelectScreen> {
  late InitDisposeFn cropToolListener = widget.vm.getCropToolListener();

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
                future: widget.vm.getSelectedImage(),
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
                    width: 720,
                    height: 1280,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.none,
                        image: MemoryImage(snapshot.data!.right),
                      ),
                    ),
                  );
                }),
            // Container(width: 100, height: 100, color: Colors.red),
            for (var i = 0; i < widget.vm.getCropToolLength(); i++)
              SizedBox(width: 720, height: 1280, child: CropTool(vm: CropToolVM(i, widget.vm.cropToolRepo)))
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
