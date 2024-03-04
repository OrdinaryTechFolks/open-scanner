import 'package:bgm_frontend/component/crop_tool.dart';
import 'package:bgm_frontend/component/crop_tool_vm.dart';
import 'package:bgm_frontend/screen/resources_create_select_vm.dart';
import 'package:flutter/material.dart';

class ResourcesCreateSelectScreen extends StatefulWidget {
  final ResourcesCreateSelectVM vm;

  ResourcesCreateSelectScreen({super.key, required this.vm}) {
    vm.addCropTool(const Offset(100, 100));
  }

  @override
  ResourcesCreateSelectScreenState createState() =>
      ResourcesCreateSelectScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateSelectScreenState
    extends State<ResourcesCreateSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop the image')),
      body: Stack(
        children: [
          FutureBuilder(
              future: widget.vm.getSelectedImage(),
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

                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: MemoryImage(snapshot.data!.right),
                    ),
                  ),
                );
              }),
          Stack(
            children: [
              for (var i = 0; i < widget.vm.getCropToolLength(); i++)
                CropTool(vm: CropToolVM(i, widget.vm.resourcesRepo))
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed("/resources/create/{id#int}/edit", arguments: {"id": 0});
                    },
                    icon: const Icon(Icons.forward))
              ],
            )),
      ),
    );
  }
}
