// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class SqliteService(
//   final String databaseName = "event.db";
//
//   Future<Database> initDB() async {
//     String path = await getDatabasesPath();
//
//     return openDatabase(
//         join(path, 'database.db'),
//         onCreate: (database, version) async {
//       await database.execute(
//           "CREATE TABLE Notes(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL)",
//     );
//   },
//     version: 1,
//     );}
// )
