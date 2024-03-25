import 'package:open_scanner/config/config.dart';
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

  final config = Config();

  final openScannerDB = SQLiteClient("open_scanner.db", 2, openScannerDBMigrations);
  await openScannerDB.initDatabase();

  final openCVRepo = OpenCVRepo();
  final cropToolRepo = CropToolRepo();
  final resourceRepo = ResourceRepo(config, openScannerDB);

 final resourcesCreateCaptureVM = ResourcesCreateCaptureVM(cropToolRepo);
 final resourcesCreateSelectVM = ResourcesCreateSelectVM(cropToolRepo, resourceRepo);
 final resourcesListVM = ResourceListVM(resourceRepo);

  runApp(MaterialApp(
      title: 'Open Scanner',
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