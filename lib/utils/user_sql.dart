// import 'dart:io';

// import 'package:enthem2/models/user.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class UserSQLRepository {
//   final String tableName = 'users';

//   static final UserSQLRepository instance = UserSQLRepository._instance();

//   UserSQLRepository._instance();

//   static Database? _db;

//   Future<Database?> get database async {
//     _db ??= await initDB();
//     return _db;
//   }

//   Future<Database> initDB() async {
//     Directory dir = await getApplicationDocumentsDirectory();
//     String path = '${dir.path}./user.db';
//     var database = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return database;
//   }

//   void _onCreate(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE users (id TEXT PRIMARY KEY, username TEXT NOT NULL, email TEXT NOT NULL, photoURL TEXT, gender TEXT, age INTEGER, interests TEXT, latitude REAL, longitude REAL);');
//   }

//   Future<bool> createUser(UserModel user) async {
//     final db = await database;
//     final registered = await db!.insert(tableName, user.toJson());
//     if (registered == 1) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> checkUserExistsSQL(String id) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db!.query(
//       tableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (maps.isEmpty) {
//       return false;
//     }
//     return true;
//   }

//   Future<UserModel?> getUserById(String id) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db!.query(
//       tableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (maps.isEmpty) {
//       return null;
//     }
//     return UserModel.fromJson(maps.first);
//   }

//   Future<bool> updateUser(UserModel user) async {
//     Database? db = await database;
//     final updated = await db!.update(
//       tableName,
//       user.toJson(),
//       where: 'id = ?',
//       whereArgs: [user.id],
//     );
//     if (updated == 1) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> deleteUserById(String id) async {
//     final db = await database;
//     int status = await db!.delete(
//       tableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (status == 1) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> addSQLInterests(String id, List<String> interests) async {
//     Database? db = await database;
//     final updated = await db!.rawUpdate('''
//       UPDATE $tableName
//       SET interests = ${interests.toString()}
//       WHERE id = $id;
//     ''');
//     if (updated == 1) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
