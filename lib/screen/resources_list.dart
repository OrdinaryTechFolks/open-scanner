
import 'package:flutter/material.dart';
import 'package:open_scanner/screen/resources_list_vm.dart';

class ResourcesListScreen extends StatelessWidget {
  final ResourceListVM vm;

  const ResourcesListScreen(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: FutureBuilder(future: vm.loadResources(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data!.isEmpty) {
          return const Text("No data");
        }

        List<Widget> resourceWidgets = [];
        for (var resource in snapshot.data!){
          resourceWidgets.add(
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: MemoryImage(resource.image!),
                    ),
                  ),
                ),
                Text(resource.name)
              ],
            )
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: resourceWidgets,
        );
      }),
      bottomNavigationBar:  BottomAppBar(
        child: SizedBox(height: 50, child: Row(
          mainAxisAlignment:  MainAxisAlignment.spaceBetween, 
          children: [
            IconButton(onPressed: () => { Navigator.of(context).pushNamed("/resources/create/capture") }, icon: const Icon(Icons.add))
          ],
        )),
      ),
    );
  }
}