import 'asset_type.dart';
class Asset {
  final String id;
  final String name;
  final AssetType type;
  

  final double currentValue;
  final double purchaseValue;

  final double quantity;

  final DateTime purchaseDate;

  final String? notes;

  const Asset({
    required this.id,
    required this.name,
    required this.type,
    required this.currentValue,
    required this.purchaseValue,
    required this.quantity,
    required this.purchaseDate,
    
    this.notes,
  });

  double get profit => currentValue - purchaseValue;

  double get profitPercentage =>
      ((currentValue - purchaseValue) / purchaseValue) * 100;
}