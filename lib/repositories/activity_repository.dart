import 'package:sqflite/sqflite.dart';

import '../databases/database_helper.dart';
import '../models/activity.dart';

class ActivityRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> addActivity(Activity activity) async {
    final Database db = await _databaseHelper.database;

    final map = activity.toMap()..remove('id');

    return await db.insert('transactions', map);
  }

  Future<List<Activity>> getRecentActivities({int limit = 10}) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
      limit: limit,
    );

    return maps.map((map) => Activity.fromMap(map)).toList();
  }

  Future<void> deleteAllActivities() async {
    final Database db = await _databaseHelper.database;
    await db.delete('transactions');
  }
}