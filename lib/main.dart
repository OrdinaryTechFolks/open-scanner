import 'package:open_scanner/config/config.dart';
import 'package:open_scanner/open_scanner_db_migrations.dart';
import 'package:open_scanner/pkg/sqlite_client.dart';
import 'package:open_scanner/repo/opencv.dart';
import 'package:open_scanner/repo/ratio.dart';
import 'package:open_scanner/repo/resource.dart';
import 'package:open_scanner/screen/resources_create_edit.dart';
import 'package:open_scanner/screen/resources_create_crop.dart';
import 'package:open_scanner/screen/resources_list.dart';
import 'package:open_scanner/screen/resources_create_capture.dart';
import 'package:open_scanner/repo/crop_tool.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = Config();

  final openScannerDB = SQLiteClient("open_scanner.db", 2, openScannerDBMigrations);
  await openScannerDB.initDatabase();

  final openCVRepo = OpenCVRepo();
  final cropToolRepo = CropToolRepo();
  final resourceRepo = ResourceRepo(config, openScannerDB);
  final ratioRepo = RatioRepo();

  runApp(MaterialApp(
      title: 'Open Scanner',
      theme: ThemeData.dark(useMaterial3: true),
      home: ResourcesListScreen(resourceRepo),
      scaffoldMessengerKey: scaffoldMessengerKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          // final arguments = settings.arguments as Map<String, Object>? ?? {};
        
          switch(settings.name) {
            case "/resources/list": return ResourcesListScreen(resourceRepo);
            case "/resources/create/capture": return ResourcesCreateCaptureScreen(cropToolRepo);
            case "/resources/create/crop": return ResourcesCreateCropScreen(cropToolRepo, resourceRepo);
            case "/resources/create/edit": 
              return ResourcesCreateEditScreen(cropToolRepo, openCVRepo, resourceRepo, ratioRepo);
          }
          return const SizedBox.shrink();
        }, settings: settings);
      },
    ));
}