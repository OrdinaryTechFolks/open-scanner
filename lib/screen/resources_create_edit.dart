import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:flutter/material.dart';

class ResourcesCreateEditScreen extends StatefulWidget {
  final int index;
  final CropToolRepo cropToolRepo;
  final OpenCVRepo openCVRepo;
  final ResourceRepo resourceRepo;

  Future<Either<Error, Uint8List>> getTransformedImage() async {
    final resource = resourceRepo.getResource(index);
    if (resource.image != null) return Right(resource.image!);

    final corners = cropToolRepo.getCropToolCorners(index);
    final destImage = openCVRepo.transform(cropToolRepo.selectedImage, corners);

    final encodeRes = await destImage.getEncodedList();
    if (encodeRes.isLeft) return Left(encodeRes.left);

    resourceRepo.setResourceImage(index, encodeRes.right);
    return Right(encodeRes.right);
  }

  int getNextIndex() {
    final nextID = index + 1;
    if (nextID >= cropToolRepo.entities.length) return -1;
    return nextID;
  }

  String getResourceName(){
    return resourceRepo.getResource(index).name;
  }

  void setResourceName(String name){
    resourceRepo.setResourceName(index, name);
  }

  Future<void> saveResources() async {
    await resourceRepo.saveResources();
  }

  const ResourcesCreateEditScreen(this.index, this.cropToolRepo, this.openCVRepo, this.resourceRepo, {super.key});

  @override
  ResourcesCreateEditScreenState createState() =>
      ResourcesCreateEditScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateEditScreenState extends State<ResourcesCreateEditScreen> {
  final TextEditingController nameFieldCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameFieldCtrl.text = widget.getResourceName();
  }
  
  @override
  void dispose() {
    super.dispose();
    nameFieldCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextID = widget.getNextIndex();
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

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: MemoryImage(snapshot.data!.right),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: nameFieldCtrl,
                  onChanged: (value) => widget.setResourceName(value),
                  decoration: const InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your document name',
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
                if (nextID != -1)
                  IconButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed(
                          "/resources/create/{id#int}/edit",
                          arguments: {"id": nextID});
                    },
                    icon: const Icon(Icons.forward),
                  ),
                if (nextID == -1)
                  IconButton(
                      onPressed: () async {
                        await widget.saveResources();
                        if (!context.mounted) return;
                        Navigator.of(context).popUntil(ModalRoute.withName("/"));
                        await Navigator.of(context).pushReplacementNamed("/");
                      }, icon: const Icon(Icons.save))
              ],
            )),
      ),
    );
  }
}
