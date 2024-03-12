import 'package:open_scanner/open_scanner_db_migrations.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:open_scanner/screen/resources_create_capture_vm.dart';
import 'package:open_scanner/screen/resources_create_edit.dart';
import 'package:open_scanner/screen/resources_create_edit_vm.dart';
import 'package:open_scanner/screen/resources_create_select.dart';
import 'package:open_scanner/screen/resources_create_select_vm.dart';
import 'package:open_scanner/screen/resources_list.dart';
import 'package:open_scanner/screen/resources_create_capture.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:flutter/material.dart';
import 'package:open_scanner/screen/resources_list_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final openScannerDB = SQLiteClient("open_scanner.db", 1, openScannerDBMigrations);
  await openScannerDB.initDatabase();

  final openCVRepo = OpenCVRepo();
  final cropToolRepo = CropToolRepo();
  final resourceRepo = ResourceRepo(openScannerDB);
  await resourceRepo.initResourcesFolder();

 final resourcesCreateCaptureVM = ResourcesCreateCaptureVM(cropToolRepo);
 final resourcesCreateSelectVM = ResourcesCreateSelectVM(cropToolRepo, resourceRepo);
 final resourcesListVM = ResourceListVM(resourceRepo);

  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: ResourcesListScreen(resourcesListVM),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          final arguments = settings.arguments as Map<String, Object>? ?? {};
        
          switch(settings.name) {
            case "/resources/list": return ResourcesListScreen(resourcesListVM);
            case "/resources/create/capture": return ResourcesCreateCaptureScreen(vm:resourcesCreateCaptureVM);
            case "/resources/create/select": return ResourcesCreateSelectScreen(vm: resourcesCreateSelectVM);
            case "/resources/create/{id#int}/edit": 
              return ResourcesCreateEditScreen(vm: ResourcesCreateEditVM(arguments["id"] as int, cropToolRepo, openCVRepo, resourceRepo));
          }
          return const SizedBox.shrink();
        }, settings: settings);
      },
    ));
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
