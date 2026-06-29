import 'asset.dart';

class Portfolio {
  final List<Asset> assets;

  const Portfolio({
    required this.assets,
  });

  double get totalValue =>
      assets.fold(0, (sum, asset) => sum + asset.currentValue);

  int get totalAssets => assets.length;
}