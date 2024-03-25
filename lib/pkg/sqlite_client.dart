import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SQLiteClient {
  final String name;
  final int version;
  final Map<int, (String, String)> migrations;

  late Database db;

  SQLiteClient(this.name, this.version, this.migrations);

  Future<void> initDatabase() async {
    DatabaseFactory factory = kIsWeb ? databaseFactoryFfiWeb : databaseFactory;

    final dbPath = join(await factory.getDatabasesPath(), name);
    db = await factory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        onCreate: (Database db, int version) async {
          for (int i = 1; i <= version; i++) {
            if (migrations[i] == null) continue;
            await db.execute(migrations[i]!.$1);
          }
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          for (int i = oldVersion + 1; i <= newVersion; i++) {
            if (migrations[i] == null) continue;
            await db.execute(migrations[i]!.$1);
          }
        },
        onDowngrade: (db, oldVersion, newVersion) async {
          for (int i = oldVersion; i > newVersion; i--) {
            if (migrations[i] == null) continue;
            await db.execute(migrations[i]!.$2);
          }
        },
        version: version,
      ),
    );
  }

  Future<void> execute(String query, {List<Object>? arguments}) async {
    await db.execute(query, arguments);
  }

  Future<List<Map<String, Object?>>> query(String query,
      {List<Object>? arguments}) async {
    return await db.rawQuery(query, arguments);
  }
}
