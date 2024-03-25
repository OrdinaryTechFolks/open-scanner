import 'dart:io';

import 'package:sqflite/sqflite.dart';

typedef Migration = (Future<String> Function(Database) async, String);

final Map<int, Migration> openScannerDBMigrations = {
  1: (
    (_) async => '''
      CREATE TABLE IF NOT EXISTS resources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image_path TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
      );
    ''',
    '''
      DROP TABLE IF EXISTS resources;
    '''
  ),
  2: (
    (db) async {
      await db.transaction((txn) async {
        txn.execute(
          "ALTER TABLE resources ADD COLUMN image_data BLOB NOT NULL DEFAULT ''",
        );

        final results = await txn.rawQuery(
          "SELECT id, image_path FROM resources",
        );

        for (var res in results) {
          final file = File(res['image_path'] as String);
          if (!await file.exists()) throw Error();

          await txn.execute(
            "UPDATE resources SET image_data = ? WHERE id = ?",
            [file.readAsBytesSync(), res["id"]],
          );
        }
      });
      
      // TODO: DROP resources.image_path field (P3)
      return "";
    },
    '''
      ALTER TABLE resources DROP COLUMN image_data;
    '''
  )
};
