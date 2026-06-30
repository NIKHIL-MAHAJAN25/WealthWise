import 'asset_type.dart';

class Asset {
  final int? id;

  final String name;

  final AssetType type;

  final double currentValue;

  final double purchaseValue;

  final double quantity;

  final DateTime purchaseDate;

  final String? notes;

  const Asset({
    this.id,
    required this.name,
    required this.type,
    required this.currentValue,
    required this.purchaseValue,
    required this.quantity,
    required this.purchaseDate,
    this.notes,
  });

  double get profit => currentValue - purchaseValue;

  double get profitPercentage {
  if (purchaseValue == 0) return 0;
  return ((currentValue - purchaseValue) / purchaseValue) * 100;
}

  Asset copyWith({
    int? id,
    String? name,
    AssetType? type,
    double? currentValue,
    double? purchaseValue,
    double? quantity,
    DateTime? purchaseDate,
    String? notes,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currentValue: currentValue ?? this.currentValue,
      purchaseValue: purchaseValue ?? this.purchaseValue,
      quantity: quantity ?? this.quantity,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type.name,
      "currentValue": currentValue,
      "purchaseValue": purchaseValue,
      "quantity": quantity,
      "purchaseDate": purchaseDate.toIso8601String(),
      "notes": notes,
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map["id"] as int?,
      name: map["name"] as String,
      type: AssetType.values.firstWhere(
        (e) => e.name == map["type"],
      ),
      currentValue: (map["currentValue"] as num).toDouble(),
      purchaseValue: (map["purchaseValue"] as num).toDouble(),
      quantity: (map["quantity"] as num).toDouble(),
      purchaseDate: DateTime.parse(map["purchaseDate"]),
      notes: map["notes"] as String?,
    );
  }
}