
import 'package:flutter/material.dart';

class ResourcesListScreen extends StatelessWidget {
  const ResourcesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: const Text("List..."),
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