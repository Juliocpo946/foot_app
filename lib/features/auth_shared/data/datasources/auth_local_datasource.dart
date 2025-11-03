import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper dbHelper;

  AuthLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final db = await dbHelper.database;
      await db.insert(
        DatabaseHelper.tableUser,
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Error al guardar usuario en DB');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.tableUser,
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return UserModel.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      throw CacheException('Error al obtener usuario de DB');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await dbHelper.database;
      await db.delete(DatabaseHelper.tableUser);
    } catch (e) {
      throw CacheException('Error al limpiar caché de usuario');
    }
  }
}