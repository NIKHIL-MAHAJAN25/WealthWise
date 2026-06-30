import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/asset_type.dart';
import '../models/activity.dart';
import '../screens/asset_type_ui.dart';
import '../providers/asset_provider.dart';
import '../screens/add_asset.dart';
import '../screens/remove_asset.dart';

class DashBoardWidget extends StatefulWidget {
  final String? userName;
  const DashBoardWidget({super.key, this.userName});

  @override
  State<DashBoardWidget> createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  static const _bg = Color(0xFFFBF6EE);
  static const _purple = Color(0xFF2E1A3C);
  static const _gold = Color(0xFFF1A93B);
  static const _coral = Color(0xFFF08A7C);
  static const _teal = Color(0xFF7FC9A8);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetProvider>().loadAssets();
      context.read<AssetProvider>().loadActivities();
    });
  }

  String _formatMoney(double value) {
    return NumberFormat("#,##0.00", "en_US").format(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssetProvider>();
    final assets = provider.assets;
    final grouped = provider.assetAllocation;
    final total = provider.totalNetWorth;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: assets.isEmpty
            ? _buildEmptyState(context)
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildNetWorthCard(provider),
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildAssetsBreakdown(grouped, total)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildNetWorthTrend(
                            provider.netWorthTrendMock,
                            provider.netWorthTrendLabels,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRecentTransactions(provider.activities),
                  const SizedBox(height: 90),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("No assets yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Add your first asset to start tracking your net worth.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAssetScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Asset"),
              style: ElevatedButton.styleFrom(backgroundColor: _purple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final name = widget.userName?.split(' ').first ?? 'there';
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: Color(0xFFFCE7C8),
          child: Icon(Icons.face, color: Colors.brown, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, $name", style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const Text(
                "WealthWise",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Serif"),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            const Icon(Icons.notifications_none, size: 28),
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetWorthCard(AssetProvider provider) {
    final gain = provider.totalGain;
    final gainPct = provider.gainPercentage;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _purple, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text("Total Net Worth", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(width: 6),
                  Icon(Icons.visibility_outlined, color: Colors.white70, size: 16),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${provider.totalAssets} assets",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "₹ ",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: _formatMoney(provider.totalNetWorth),
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                gain >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: gain >= 0 ? Colors.greenAccent : Colors.redAccent,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                "${gainPct.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: gain >= 0 ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              const Text("overall gain/loss", style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ("Remove Asset", Icons.remove_circle_outline, _coral),
      ("Goals", Icons.flag_outlined, _teal),
    ];

    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: GestureDetector(
                onTap: () {
                  if (a.$1 == "Remove Asset") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RemoveAssetScreen()),
                    );
                  }
                  // TODO: wire up Goals when that screen exists.
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: (a.$3 as Color).withOpacity(0.15),
                        child: Icon(a.$2 as IconData, color: a.$3 as Color, size: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(a.$1 as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAssetsBreakdown(Map<AssetType, double> grouped, double total) {
    final entries = grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Assets Breakdown", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: entries.map((e) {
                  return PieChartSectionData(
                    value: e.value,
                    color: e.key.color,
                    radius: 22,
                    showTitle: false,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...entries.map((e) {
            final pct = total == 0 ? 0.0 : (e.value / total) * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: e.key.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      e.key.displayLabel,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text("${pct.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Mocked previous-month points (since there's no historical snapshot
  /// data), with the real current net worth as the last point.
  Widget _buildNetWorthTrend(List<double> trend, List<String> labels) {
    final change = trend.first == 0 ? 0.0 : ((trend.last - trend.first) / trend.first) * 100;
    final minY = trend.reduce((a, b) => a < b ? a : b) * 0.95;
    final maxY = trend.reduce((a, b) => a > b ? a : b) * 1.05;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Net Worth Trend", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: change >= 0 ? Colors.green : Colors.redAccent,
                size: 13,
              ),
              const SizedBox(width: 3),
              Text(
                "${change.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: change >= 0 ? Colors.green : Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(trend.length, (i) => FlSpot(i.toDouble(), trend[i])),
                    isCurved: true,
                    color: _purple,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: _purple.withOpacity(0.12)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(labels.first, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(labels.last, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  /// Real activity log: every Add Asset / Remove Asset action, sourced
  /// from the `transactions` table via ActivityRepository.
  Widget _buildRecentTransactions(List<Activity> activities) {
    final recent = activities.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Transactions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("View All", style: TextStyle(color: _purple, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          if (recent.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text("No recent activity yet.", style: TextStyle(color: Colors.grey)),
            ),
          ...recent.map((a) {
            final color = a.isExpense ? Colors.redAccent : Colors.green;
            final icon = a.isExpense ? Icons.remove_circle_outline : Icons.add_circle_outline;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withOpacity(0.15),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(
                          "${a.subtitle} · ${DateFormat('MMM d, yyyy').format(a.date)}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${a.isExpense ? '-' : '+'} ₹ ${_formatMoney(a.amount)}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}