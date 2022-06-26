import 'dart:io';

import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //static const _dbVersion = 1;
  static const _dbName = 'snapchat.db';

  static const String countryTable = "CountryCode";
  static const String countryId = "id";
  static const String countryCode = "code";
  static const String countryFullName = "fullName";
  static const String countryShortName = "shortName";
  static const String countryFlag = "flag";

  static const String userTable = "User";
  static const String userId = "id";
  static const String userFirstName = "firstName";
  static const String userLastName = "lastName";
  static const String userBirthdate = "birthdate";
  static const String userUsername = "username";
  static const String userEmail = "email";
  static const String userPassword = "password";
  static const String userPhone = "phone";

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, _dbName);
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
                     CREATE TABLE $userTable (  
                    $userId INTEGER PRIMARY KEY AUTOINCREMENT,
                    $userFirstName TEXT NOT NULL,
                    $userLastName TEXT NOT NULL,
                    $userBirthdate TEXT NOT NULL,
                    $userUsername TEXT NOT NULL,
                    $userEmail TEXT NOT NULL,
                    $userPassword TEXT NOT NULL,
                    $userPhone TEXT NOT NULL
                    )
              ''');
      await db.execute('''
                    CREATE TABLE $countryTable (
                    $countryId INTEGER PRIMARY KEY AUTOINCREMENT,
                    $countryCode TEXT NOT NULL,
                    $countryFullName TEXT NOT NULL,
                    $countryShortName TEXT NOT NULL,
                    $countryFlag TEXT NOT NULL)
              ''');
    });
  }

  Future<int?> insertCountryCode(CountryCodeModel countryCodeModel) async {
    final Map<String, dynamic> row = {
      DatabaseHelper.countryId: null,
      DatabaseHelper.countryFullName: countryCodeModel.fullName,
      DatabaseHelper.countryCode: countryCodeModel.code,
      DatabaseHelper.countryShortName: countryCodeModel.shortName,
      DatabaseHelper.countryFlag: countryCodeModel.flag,
    };
    final Database? db = await instance.database;
    return db?.insert(countryTable, row);
  }

  Future<int?> insertUser(UserModel user) async {
    final Map<String, dynamic> row = {
      DatabaseHelper.userFirstName: user.firstName,
      DatabaseHelper.userLastName: user.lastName,
      DatabaseHelper.userBirthdate: user.birthdate.toString(),
      DatabaseHelper.userUsername: user.username,
      DatabaseHelper.userEmail: user.email,
      DatabaseHelper.userPassword: user.password,
      DatabaseHelper.userPhone: user.phone,
    };
    final Database? db = await instance.database;
    return db?.insert(userTable, row);
  }

  Future updateCountry(Map<String, dynamic> row) async {
    final Database? db = await instance.database;
    final int id = row[countryId];
    db?.update(countryTable, row, where: '$countryId = ?', whereArgs: [id]);
  }

  Future updateUser(Map<String, dynamic> row) async {
    final Database? db = await instance.database;
    final int id = row[countryId];
    db?.update(userTable, row, where: '$userId = ?', whereArgs: [id]);
  }

  Future<int?> deleteCountryCode(int id) async {
    final Database? db = await instance.database;
    return db?.delete(countryTable, where: '$countryId = ?', whereArgs: [id]);
  }

  Future<int?> deleteUser(int id) async {
    final Database? db = await instance.database;
    return db?.delete(userTable, where: '$userId = ?', whereArgs: [id]);
  }

//you can send name as argument
  Future<bool> isEmptyCountryCodeTable() async {
    final Database? db = await instance.database;
    final result = await db!.rawQuery('SELECT COUNT(*) FROM $countryTable');
    final count = Sqflite.firstIntValue(result);
    return count == 0;
  }

  Future<bool?> isEmptyUserTable() async {
    final Database? db = await instance.database;
    final result = await db!.rawQuery('SELECT COUNT(*) FROM $userTable');
    final count = Sqflite.firstIntValue(result);
    return count == 0;
  }

  Future<void> multipleInsertCountryCode(
      List<CountryCodeModel> countryList) async {
    final Database? db = await instance.database;
    await db?.transaction((txn) async {
      final batch = txn.batch();
      for (final CountryCodeModel country in countryList) {
        final Map<String, dynamic> countryCode = country.toMap();
        batch.insert(countryTable, countryCode);
      }
      await batch.commit();
    });
  }

  //you can send name as argument
  Future<void> multipleInsertUser(List<UserModel> userList) async {
    final Database? db = await instance.database;
    await db?.transaction((txn) async {
      final batch = txn.batch();
      for (final UserModel userItem in userList) {
        final Map<String, dynamic> user = userItem.toMap();
        batch.insert(userTable, user);
      }
      await batch.commit();
    });
  }

  Future<List<CountryCodeModel>?> queryAllCountryCodes() async {
    final Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(countryTable);
    return List.generate(maps.length, (i) {
      return CountryCodeModel.fromMap(maps[i]);
    });
  }

  Future<List<UserModel>?> queryAllUsers() async {
    final Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(userTable);
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<List<UserModel>> getUserByUsername(String username) async {
    final Database db = (await instance.database)!;
    final List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: "$userUsername = ?",
      whereArgs: [username],
    );

    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<List<CountryCodeModel>> filter(String country) async {
    final Database db = (await instance.database)!;
    final List<Map<String, dynamic>> maps = await db.query(
      countryTable,
      where: "$countryFullName LIKE ?",
      whereArgs: ['%$country%'],
    );
    return List.generate(maps.length, (i) {
      return CountryCodeModel.fromMap(maps[i]);
    });
  }

  Future<List<UserModel>> getUserByEmail(String email) async {
    final Database db = (await instance.database)!;
    final List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: "$userEmail = ?",
      whereArgs: [email],
    );
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<UserModel> getUserById(String userID) async {
    final Database db = (await instance.database)!;
    final List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: "$userId = ?",
      whereArgs: [userID],
    );
    final list = List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
    //print(list.toString());
    return list[0];
  }

  Future<List<UserModel>> getUserByPhone(String phone) async {
    final Database db = (await instance.database)!;
    final List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: "$userPhone = ?",
      whereArgs: [phone],
    );
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<UserModel?> getSignUpUser(
      String usernameOrEmail, String password) async {
    final Database db = (await instance.database)!;
    final List<Map<String, dynamic>> maps = await db.query(
      userTable,
      where: "$userUsername = ? AND $userPassword = ?",
      whereArgs: [usernameOrEmail, password],
    );
    final List<UserModel> users = List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
    return users.isEmpty ? null : users[0];
  }
}
