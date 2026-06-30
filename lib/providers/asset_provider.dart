import 'package:flutter/material.dart';

import '../models/asset.dart';
import '../models/asset_type.dart';
import '../models/activity.dart';
import '../repositories/asset_repository.dart';
import '../repositories/activity_repository.dart';
import '../screens/asset_type_ui.dart'; // for AssetType.displayLabel

class AssetProvider extends ChangeNotifier {
  final AssetRepository _repository = AssetRepository();
  final ActivityRepository _activityRepository = ActivityRepository();

  List<Asset> _assets = [];
  List<Activity> _activities = [];

  List<Asset> get assets => _assets;
  List<Activity> get activities => _activities;

  Future<void> loadAssets() async {
    _assets = await _repository.getAssets();
    notifyListeners();
  }

  Future<void> loadActivities() async {
    _activities = await _activityRepository.getRecentActivities(limit: 10);
    notifyListeners();
  }

  Future<void> addAsset(Asset asset) async {
    final newId = await _repository.addAsset(asset);
    await loadAssets();

    await _activityRepository.addActivity(Activity(
      title: "Added ${asset.name}",
      subtitle: asset.type.displayLabel,
      amount: asset.currentValue,
      date: DateTime.now(),
      isExpense: false,
      assetId: newId,
    ));
    await loadActivities();
  }

  Future<void> updateAsset(Asset asset) async {
    await _repository.updateAsset(asset);
    await loadAssets();
  }

  Future<void> deleteAsset(int id) async {
    await _repository.deleteAsset(id);
    await loadAssets();
  }

  /// Removes [removeQty] units from [asset]. If it covers the whole
  /// holding, the asset is deleted entirely. Otherwise quantity/value
  /// are reduced proportionally. Logs an activity either way.
  Future<void> removeAssetQuantity(Asset asset, double removeQty) async {
    if (removeQty >= asset.quantity) {
      final removedValue = asset.currentValue;
      await _repository.deleteAsset(asset.id!);

      await _activityRepository.addActivity(Activity(
        title: "Removed ${asset.name}",
        subtitle: asset.type.displayLabel,
        amount: removedValue,
        date: DateTime.now(),
        isExpense: true,
        assetId: asset.id,
      ));
    } else {
      final perUnitCurrent = asset.currentValue / asset.quantity;
      final perUnitPurchase = asset.purchaseValue / asset.quantity;
      final valueRemoved = perUnitCurrent * removeQty;

      final updated = asset.copyWith(
        quantity: asset.quantity - removeQty,
        currentValue: asset.currentValue - valueRemoved,
        purchaseValue: asset.purchaseValue - (perUnitPurchase * removeQty),
      );

      await _repository.updateAsset(updated);

      await _activityRepository.addActivity(Activity(
        title: "Removed ${asset.name}",
        subtitle: asset.type.displayLabel,
        amount: valueRemoved,
        date: DateTime.now(),
        isExpense: true,
        assetId: asset.id,
      ));
    }

    await loadAssets();
    await loadActivities();
  }

  double get totalNetWorth {
    return _assets.fold(0, (sum, asset) => sum + asset.currentValue);
  }

  double get totalPurchaseValue {
    return _assets.fold(0, (sum, asset) => sum + asset.purchaseValue);
  }

  double get totalGain => totalNetWorth - totalPurchaseValue;

  double get gainPercentage {
    if (totalPurchaseValue == 0) return 0;
    return totalGain / totalPurchaseValue * 100;
  }

  int get totalAssets => _assets.length;

  Asset? get topAsset {
    if (_assets.isEmpty) return null;
    Asset top = _assets.first;
    for (final asset in _assets) {
      if (asset.currentValue > top.currentValue) top = asset;
    }
    return top;
  }

  List<Asset> get topHoldings {
    final list = List<Asset>.from(_assets);
    list.sort((a, b) => b.currentValue.compareTo(a.currentValue));
    return list;
  }

  List<Asset> filteredAssets(int tab) {
    switch (tab) {
      case 1:
        return _assets.where((a) {
          return [
            AssetType.stocks,
            AssetType.mutualFund,
            AssetType.fixedDeposit,
            AssetType.crypto,
          ].contains(a.type);
        }).toList();
      case 2:
        return _assets.where((a) => a.type == AssetType.cash).toList();
      case 3:
        return _assets.where((a) {
          return [AssetType.property, AssetType.gold].contains(a.type);
        }).toList();
      default:
        return _assets;
    }
  }

  Map<AssetType, double> get assetAllocation {
    final Map<AssetType, double> allocation = {};
    for (final asset in _assets) {
      allocation.update(
        asset.type,
        (value) => value + asset.currentValue,
        ifAbsent: () => asset.currentValue,
      );
    }
    return allocation;
  }

  /// No historical snapshots exist yet, so this fakes 5 prior months
  /// using fixed multipliers of the *real* current net worth, with the
  /// real total as the final (most recent) point.
  List<double> get netWorthTrendMock {
    final total = totalNetWorth;
    if (total == 0) return List.filled(6, 0);
    const multipliers = [0.62, 0.70, 0.78, 0.74, 0.88, 1.0];
    return multipliers.map((m) => total * m).toList();
  }

  List<String> get netWorthTrendLabels {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return List.generate(6, (i) {
      var idx = (now.month - 1) - (5 - i);
      idx = idx % 12;
      if (idx < 0) idx += 12;
      return months[idx];
    });
  }
}