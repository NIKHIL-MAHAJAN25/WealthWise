import 'package:sqflite/sqflite.dart';

import '../databases/database_helper.dart';
import '../models/asset.dart';

class AssetRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> addAsset(Asset asset) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'assets',
      asset.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Asset>> getAssets() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'assets',
      orderBy: 'purchaseDate DESC',
    );

    return maps.map((map) => Asset.fromMap(map)).toList();
  }

  Future<int> updateAsset(Asset asset) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'assets',
      asset.toMap(),
      where: 'id = ?',
      whereArgs: [asset.id],
    );
  }

  Future<int> deleteAsset(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Asset?> getAssetById(int id) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return Asset.fromMap(maps.first);
  }

  Future<void> deleteAllAssets() async {
    final Database db = await _databaseHelper.database;

    await db.delete('assets');
  }
}