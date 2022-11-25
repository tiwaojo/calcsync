import 'package:calendar_sync/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EventsDatabase {
  static final EventsDatabase instance = EventsDatabase._init();
  String databaseName = "event.db";

  static Database? _database;

  EventsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, databaseName),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE events(id TEXT PRIMARY KEY, description TEXT NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL, startTime TEXT NOT NULL, endTime TEXT NOT NULL)",
        );
      },
    );
  }

  Future<int> createItem(Event event) async {
    final Database db = await initializeDatabase();
    return await db.insert('events', event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Event>> getItems() async {
    final db = await initializeDatabase();
    final List<Map<String, Object?>> queryResult = await db.query('events');
    return queryResult.map((e) => Event.fromMap(e)).toList();
  }

  Future<int> update(Event event) async {
    Database db = await initializeDatabase();
    Object? id = event.toMap()['id'];
    return await db
        .update('events', event.toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteItem(String id) async {
    final db = await initializeDatabase();
    try {
      await db.delete("events", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
