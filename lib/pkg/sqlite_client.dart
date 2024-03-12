import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteClient {
  final String name;
  final int version;
  final Map<int, (String, String)> migrations;

  late Database db;

  SQLiteClient(this.name, this.version, this.migrations);

  Future<void> initDatabase() async {
    final dbPath = join(await getDatabasesPath(), name);
    db = await openDatabase(
      dbPath,
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
    );
  }

  Future<void> execute(String query, {List<Object>? arguments}) async {
    await db.execute(query, arguments);
  }

  Future<List<Map<String, Object?>>> query(
      String query, {List<Object>? arguments}) async {
    return await db.rawQuery(query, arguments);
  }
}
