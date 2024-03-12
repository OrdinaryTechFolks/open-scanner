final Map<int, (String, String)> openScannerDBMigrations = {
  1: (
    '''
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
};
