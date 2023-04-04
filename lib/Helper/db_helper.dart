import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'schoolrecd.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE school_record (id TEXT PRIMARY KEY, name TEXT, image TEXT, category TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  //to add to database
  static Future<void> insert(String schTable, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(schTable, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }


  //to get back data from database
  static Future<List<Map<String, dynamic>>> getData (String table)async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
