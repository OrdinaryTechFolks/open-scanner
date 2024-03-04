
import 'package:bgm_frontend/screen/resources_create_edit_vm.dart';
import 'package:flutter/material.dart';


class ResourcesCreateEditScreen extends StatefulWidget {
  final ResourcesCreateEditVM vm;

  const ResourcesCreateEditScreen({super.key, required this.vm});

  @override
  ResourcesCreateEditScreenState createState() =>
      ResourcesCreateEditScreenState();
}

// A widget that displays the picture taken by the user.
class ResourcesCreateEditScreenState extends State<ResourcesCreateEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit the resource')),
      body: FutureBuilder(
          future: widget.vm.getTransformedImage(),
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
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed("/resources/create/{id#int}/edit", arguments: {"id": widget.vm.index+1});
                    },
                    icon: const Icon(Icons.forward))
              ],
            )),
      ),
    );
  }
}
