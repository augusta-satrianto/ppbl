import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openMyDatabase() async {
  final _databaseName = "myDatabase.db";
  final _databaseVersion = 1;

  final tableSaham = 'saham';

  final columnTickerId = 'tickerid';
  final columnTicker = 'ticker';
  final columnOpen = 'open';
  final columnHigh = 'high';
  final columnLast = 'last';
  final columnChange = 'change';

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, _databaseName);

  final database = await openDatabase(
    path,
    version: _databaseVersion,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableSaham (
          $columnTickerId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTicker   TEXT NOT NULL,
          $columnOpen     INTEGER,
          $columnHigh     INTEGER,
          $columnLast     INTEGER,
          $columnChange   REAL
        )
      ''');
    },
  );

  return database;
}
