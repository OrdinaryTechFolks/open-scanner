import 'package:open_scanner/screen/resources_create_edit_vm.dart';
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
  final TextEditingController nameFieldCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameFieldCtrl.text = widget.vm.getResourceName();
  }
  
  @override
  void dispose() {
    super.dispose();
    nameFieldCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextID = widget.vm.getNextIndex();
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

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: MemoryImage(snapshot.data!.right),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: nameFieldCtrl,
                  onChanged: (value) => widget.vm.setResourceName(value),
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
                        await widget.vm.saveResources();
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
