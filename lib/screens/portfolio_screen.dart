import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import '../providers/asset_provider.dart';

import '../models/asset.dart';
import '../models/asset_type.dart';

// ── Theme constants ───────────────────────────────────────────────────────────

const Color kPurpleDark = Color(0xFF2D1B69);
const Color kPurpleMid = Color(0xFF3D2680);
const Color kGreen = Color(0xFF4AC9A4);
const Color kBg = Color(0xFFF8F7FC);
const Color kCardBg = Color(0xFFFFFFFF);
const Color kTextPrimary = Color(0xFF1A1A2E);
const Color kTextSec = Color(0xFF6B6B8A);

// Colours and icons per AssetType — kept here so models stay plain data classes
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

  /// Human-readable label — falls back to the enum name if your model
  /// already exposes one (adjust if AssetType already has a `label` getter).
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

String _fmt(double v) {
  if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(2)}L';
  if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
  return '₹${v.toStringAsFixed(0)}';
}

// ── Portfolio Widget ──────────────────────────────────────────────────────────

class PortfolioWidget extends StatefulWidget {
  const PortfolioWidget({super.key});

  @override
  State<PortfolioWidget> createState() => _PortfolioWidgetState();
}

class _PortfolioWidgetState extends State<PortfolioWidget> {
  int _selectedTab = 0;
  bool _hideValue = false;

  // Filter tab labels — index must line up with AssetProvider.filteredAssets(tab)
  static const List<String> _tabs = ['All', 'Investments', 'Cash', 'Property & Gold'];

  @override
  void initState() {
    super.initState();
    // Safe to call even if DashBoardWidget already loaded — loadAssets()
    // just re-queries SQLite and notifies listeners.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetProvider>().loadAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssetProvider>();

    final assets = provider.assets;
    final filtered = provider.filteredAssets(_selectedTab);
    final totalValue = provider.totalNetWorth;
    final gain = provider.totalGain;
    final gainPercentage = provider.gainPercentage;
    final topHoldings = provider.topHoldings;
    final allocation = provider.assetAllocation; // Map<AssetType, double>, grouped & summed

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      body: SafeArea(
        child: assets.isEmpty
            ? _buildEmptyState(context)
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(totalValue, gain, gainPercentage, allocation),
                  ),
                  SliverToBoxAdapter(child: _buildTabs()),
                  filtered.isEmpty
                      ? SliverToBoxAdapter(child: _buildNoMatchForTab())
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) =>
                                _AssetRow(asset: filtered[i], totalValue: totalValue),
                            childCount: filtered.length,
                          ),
                        ),
                  SliverToBoxAdapter(child: _buildAllocation(allocation, totalValue)),
                  SliverToBoxAdapter(child: _buildTopHoldings(topHoldings)),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }

  // ── Empty states ──
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pie_chart_outline, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "No portfolio data yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add an asset to see your allocation, holdings, and gains.",
              textAlign: TextAlign.center,
              style: TextStyle(color: kTextSec),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatchForTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          "No assets in this category",
          style: TextStyle(color: kTextSec, fontSize: 13),
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(
    double totalValue,
    double gain,
    double gainPercentage,
    Map<AssetType, double> allocation,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPurpleDark, kPurpleMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Portfolio Value',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _hideValue = !_hideValue),
                      child: Icon(
                        _hideValue ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _hideValue ? '••••••' : _fmt(totalValue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      gain >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: gain >= 0 ? kGreen : Colors.redAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${gainPercentage.toStringAsFixed(2)}% (${gain >= 0 ? '+' : ''}${_fmt(gain)})',
                      style: TextStyle(
                        color: gain >= 0 ? kGreen : Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'overall, since purchase',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _DonutChart(allocation: allocation, totalValue: totalValue),
        ],
      ),
    );
  }

  // ── Filter tabs ──
  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final sel = i == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? kPurpleDark : kCardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? kPurpleDark : const Color(0xFFE0DDED),
                ),
              ),
              child: Text(
                _tabs[i],
                style: TextStyle(
                  color: sel ? Colors.white : kTextSec,
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Asset Allocation ──
  Widget _buildAllocation(
    Map<AssetType, double> allocation,
    double totalValue,
  ) {
    final entries = allocation.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // largest holding first

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Asset Allocation',
            style: TextStyle(
              color: kTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DonutChart(allocation: allocation, totalValue: totalValue, size: 120),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: entries.map((e) {
                    final pct = totalValue == 0
                        ? 0
                        : (e.value / totalValue * 100).round();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: e.key.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e.key.displayLabel,
                              style: const TextStyle(
                                color: kTextPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '$pct%',
                            style: const TextStyle(
                              color: kTextPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Top Holdings ──
  Widget _buildTopHoldings(List<Asset> top3) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Holdings',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: kPurpleDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...top3.take(3).map((a) => _HoldingRow(asset: a)),
        ],
      ),
    );
  }
}

// ── Asset row ─────────────────────────────────────────────────────────────────

class _AssetRow extends StatelessWidget {
  final Asset asset;
  final double totalValue;

  const _AssetRow({required this.asset, required this.totalValue});

  @override
  Widget build(BuildContext context) {
    final pct = totalValue == 0 ? 0.0 : asset.currentValue / totalValue;
    final gain = asset.profitPercentage; // model already guards purchaseValue == 0

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: asset.type.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(asset.type.icon, color: asset.type.color, size: 20),
              ),
              const SizedBox(width: 12),
              // Label + share of portfolio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.type.displayLabel,
                      style: const TextStyle(
                        color: kTextPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(pct * 100).toStringAsFixed(0)}% of portfolio',
                      style: const TextStyle(color: kTextSec, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Value + gain badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(asset.currentValue),
                    style: const TextStyle(
                      color: kTextPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        gain >= 0
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        color: gain >= 0 ? kGreen : Colors.red,
                        size: 12,
                      ),
                      Text(
                        '${gain.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: gain >= 0 ? kGreen : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              backgroundColor: asset.type.color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(asset.type.color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Holding row ───────────────────────────────────────────────────────────────

class _HoldingRow extends StatelessWidget {
  final Asset asset;
  const _HoldingRow({required this.asset});

  @override
  Widget build(BuildContext context) {
    final gain = asset.profitPercentage; // safe against purchaseValue == 0

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: asset.type.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(asset.type.icon, color: asset.type.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${asset.quantity % 1 == 0 ? asset.quantity.toInt() : asset.quantity}'
                  ' ${asset.type == AssetType.stocks ? "Shares" : "Units"}',
                  style: const TextStyle(color: kTextSec, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _fmt(asset.currentValue),
                style: const TextStyle(
                  color: kTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Icon(
                    gain >= 0
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: gain >= 0 ? kGreen : Colors.red,
                    size: 12,
                  ),
                  Text(
                    '${gain.abs().toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: gain >= 0 ? kGreen : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Donut chart ───────────────────────────────────────────────────────────────

class _DonutChart extends StatelessWidget {
  final Map<AssetType, double> allocation;
  final double totalValue;
  final double size;

  const _DonutChart({
    required this.allocation,
    required this.totalValue,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _DonutPainter(allocation: allocation, totalValue: totalValue),
        ),
      );
}

class _DonutPainter extends CustomPainter {
  final Map<AssetType, double> allocation;
  final double totalValue;

  _DonutPainter({required this.allocation, required this.totalValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Guard against a fresh/empty SQLite table — totalValue == 0 would
    // otherwise produce a NaN sweep angle and crash drawArc.
    if (totalValue <= 0 || allocation.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2;
    final innerR = outerR * 0.55;
    final strokeW = outerR - innerR;
    double startAngle = -math.pi / 2;
    const gap = 0.04;

    // One arc per AssetType (already summed), not per individual asset.
    for (final entry in allocation.entries) {
      final rawSweep = (entry.value / totalValue) * 2 * math.pi;
      final sweep = math.max(rawSweep - gap, 0.01);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (outerR + innerR) / 2),
        startAngle,
        sweep,
        false,
        Paint()
          ..color = entry.key.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.allocation != allocation || oldDelegate.totalValue != totalValue;
  }
}