import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:finalproject/model/user.dart';
import 'package:finalproject/service/database_helper.dart';

class userDatabaseHelper {
  static String tableName = 'User';

  static Future<void> createUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    var username = user.username;
    var key = utf8.encode(user.password.toString());
    var digest = sha1.convert(key);
    user.password = digest.toString();

    List<Map> list = await db!.query('$tableName',
        where: 'username = ?', whereArgs: [username]);

    if (list.isEmpty) {
      await db.insert(tableName, user.toMap());
    } else {
      throw Exception('Username or email already exists');
    }
  }

  static Future<List<UserModel>> getUsers() async {
    final db = await DatabaseHelper.instance.database;
    List<Map> list = await db!.query('$tableName');

    List<UserModel> users = [];

    for (var item in list) {
      var user = UserModel.fromMap(item);
      users.add(user);
    }
    print(users);

    return users;
  }

  static Future<UserModel> getUsersById(int userId) async {
    print(userId);
    UserModel user = UserModel(username: '', password: '');
    final db = await DatabaseHelper.instance.database;
    List<Map> list =
        await db!.query('$tableName', where: 'id = ?', whereArgs: [userId]);

    print(list);
    if (list.isEmpty) {
      return user;
    }
    user = UserModel.fromMap(list[0]);

    return user;
  }

  static Future<List<UserModel>> getUserByUsernameAndPassword(
      String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    List<Map> list = await db!
        .query('$tableName', where: 'username = ?', whereArgs: [username]);

    List<UserModel> users = [];

    if (list.isEmpty) {
      throw Exception('Username or password is incorrect');
    }

    var key = utf8.encode(password);
    var digest = sha1.convert(key);

    if (list[0]['password'] != digest.toString()) {
      throw Exception('Username or password is incorrect');
    }

    for (var item in list) {
      var user = UserModel.fromMap(item);
      users.add(user);
    }
    return users;
  }

  static Future<void> updateUser(UserModel user) async {
    final db = await DatabaseHelper.instance.database;
    await db!
        .update(tableName, user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  static Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
