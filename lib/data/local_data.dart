import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:onedeal_app/model/user.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "onedeal.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Users(id TEXT PRIMARY KEY, first_name TEXT, second_name TEXT, email TEXT, users_type TEXT, token TEXT, org_id INTEGER, is_admin INTEGER, city TEXT, dob TEXT)");
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Users');
    List<User> users = [];
    for (int i = 0; i < list.length; i++) {
      var user = User();
      user.id = list[i]["id"];
      user.firstName = list[i]["first_name"];
      user.secondName = list[i]["second_name"];
      user.email = list[i]["email"];
      user.userType = list[i]["users_type"];
      user.token = list[i]["token"];
      user.companyID = list[i]["org_id"];
      user.isAdmin = list[i]["is_admin"];
      user.city = list[i]["city"];
      user.dob = list[i]["dob"];
      users.add(user);
    }
    return users;
  }

  Future<void> deleteUser() async {
    var dbClient = await db;
    await dbClient!.transaction((txn) async {
      return await txn.rawDelete('DELETE FROM Users');
    });
  }

  Future<void> saveUser(User user) async {
    var dbClient = await db;
    await deleteUser();
    await dbClient!.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Users(id, first_name, second_name, email, users_type, token, org_id, is_admin, city, dob ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            user.id,
            user.firstName,
            user.secondName,
            user.email,
            user.userType,
            user.token,
            user.companyID,
            user.isAdmin,
            user.city,
            user.dob
          ]);
    });
  }
}
