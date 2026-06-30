// asset_type_ui.dart
//
// Single source of truth for how each AssetType is displayed: color, icon,
// human-readable label. Import this everywhere instead of redefining your
// own map/switch per screen — that's what caused "Gold" to be a different
// color on the Dashboard vs Portfolio vs Add Asset screens.

import 'package:flutter/material.dart';
import '../models/asset_type.dart';

extension AssetTypeUI on AssetType {
  Color get color {
    switch (this) {
      case AssetType.stocks:
        return const Color(0xFF7C5CBF);
      case AssetType.mutualFund:
        return const Color(0xFF4AC9A4);
      case AssetType.gold:
        return const Color(0xFFE8524A);
      case AssetType.property:
        return const Color(0xFFF6AF05);
      case AssetType.cash:
        return const Color(0xFF4CAF50);
      case AssetType.crypto:
        return const Color(0xFF2196F3);
      case AssetType.fixedDeposit:
        return const Color(0xFF9C27B0);
    }
  }

  IconData get icon {
    switch (this) {
      case AssetType.stocks:
        return Icons.trending_up_rounded;
      case AssetType.mutualFund:
        return Icons.donut_large_rounded;
      case AssetType.property:
        return Icons.home_rounded;
      case AssetType.gold:
        return Icons.layers_rounded;
      case AssetType.cash:
        return Icons.account_balance_wallet_rounded;
      case AssetType.crypto:
        return Icons.currency_bitcoin_rounded;
      case AssetType.fixedDeposit:
        return Icons.account_balance_rounded;
    }
  }

  String get displayLabel {
    switch (this) {
      case AssetType.stocks:
        return 'Stocks';
      case AssetType.mutualFund:
        return 'Mutual Funds';
      case AssetType.property:
        return 'Real Estate';
      case AssetType.gold:
        return 'Gold';
      case AssetType.cash:
        return 'Cash';
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.fixedDeposit:
        return 'Fixed Deposit';
    }
  }
}