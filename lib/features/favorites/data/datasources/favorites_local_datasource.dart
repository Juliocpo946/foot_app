import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';

abstract class FavoritesLocalDataSource {
  Future<List<String>> getFavoriteMealIds();
  Future<void> addFavoriteMealId(String mealId);
  Future<void> removeFavoriteMealId(String mealId);
  Future<void> clearFavorites();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final DatabaseHelper dbHelper;

  FavoritesLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<String>> getFavoriteMealIds() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(DatabaseHelper.tableFavorites);
      return maps.map((map) => map['mealId'] as String).toList();
    } catch (e) {
      throw CacheException('Error al obtener favoritos de DB');
    }
  }

  @override
  Future<void> addFavoriteMealId(String mealId) async {
    try {
      final db = await dbHelper.database;
      await db.insert(
        DatabaseHelper.tableFavorites,
        {'mealId': mealId},
      );
    } catch (e) {
      throw CacheException('Error al añadir favorito en DB');
    }
  }

  @override
  Future<void> removeFavoriteMealId(String mealId) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        DatabaseHelper.tableFavorites,
        where: 'mealId = ?',
        whereArgs: [mealId],
      );
    } catch (e) {
      throw CacheException('Error al eliminar favorito de DB');
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      final db = await dbHelper.database;
      await db.delete(DatabaseHelper.tableFavorites);
    } catch (e) {
      throw CacheException('Error al limpiar favoritos');
    }
  }
}