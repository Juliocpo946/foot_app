import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();

  Future<List<String>> getFavoriteMealIds();
  Future<void> addFavoriteMealId(String mealId);
  Future<void> removeFavoriteMealId(String mealId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';
  static const String favoriteMealsKey = 'FAVORITE_MEALS';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      await sharedPreferences.setString(cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException('Error al guardar usuario');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw CacheException('Error al obtener usuario');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
      await sharedPreferences.remove(favoriteMealsKey);
    } catch (e) {
      throw CacheException('Error al limpiar caché');
    }
  }

  @override
  Future<List<String>> getFavoriteMealIds() async {
    try {
      return sharedPreferences.getStringList(favoriteMealsKey) ?? [];
    } catch (e) {
      throw CacheException('Error al obtener favoritos');
    }
  }

  @override
  Future<void> addFavoriteMealId(String mealId) async {
    try {
      final ids = await getFavoriteMealIds();
      if (!ids.contains(mealId)) {
        ids.add(mealId);
        await sharedPreferences.setStringList(favoriteMealsKey, ids);
      }
    } catch (e) {
      throw CacheException('Error al añadir favorito');
    }
  }

  @override
  Future<void> removeFavoriteMealId(String mealId) async {
    try {
      final ids = await getFavoriteMealIds();
      if (ids.contains(mealId)) {
        ids.remove(mealId);
        await sharedPreferences.setStringList(favoriteMealsKey, ids);
      }
    } catch (e) {
      throw CacheException('Error al eliminar favorito');
    }
  }
}