import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';


import '../models/asset_type.dart';
import '../models/asset.dart';
import '../mock/mock_assets.dart'; // adjust import path to wherever your mock file lives

class DashBoardWidget extends StatefulWidget {
  const DashBoardWidget({super.key});

  @override
  State<DashBoardWidget> createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  static const _bg = Color(0xFFFBF6EE);
  static const _purple = Color(0xFF2E1A3C);
  static const _gold = Color(0xFFF1A93B);
  static const _coral = Color(0xFFF08A7C);
  static const _teal = Color(0xFF7FC9A8);

  // Map each AssetType to a display color used in the donut + legend
  Color _colorForType(AssetType type) {
    switch (type) {
      case AssetType.stocks:
      return _purple;
    case AssetType.mutualFund:
      return const Color(0xFF5B8DEF);
    case AssetType.gold:
      return _gold;
    case AssetType.cash:
      return _teal;
    case AssetType.crypto:
      return _coral;
    case AssetType.fixedDeposit:
      return const Color(0xFF8E7CC3);
    case AssetType.property:
      return const Color(0xFFB07D5C);
    }
  }

  IconData _iconForType(AssetType type) {
    switch (type) {
       case AssetType.stocks:
      return Icons.show_chart;
    case AssetType.mutualFund:
      return Icons.stacked_line_chart;
    case AssetType.gold:
      return Icons.diamond_outlined;
    case AssetType.cash:
      return Icons.account_balance_wallet_outlined;
    case AssetType.crypto:
      return Icons.currency_bitcoin;
    case AssetType.fixedDeposit:
      return Icons.savings_outlined;
    case AssetType.property:
      return Icons.home_outlined;
    }
  }

  String _typeLabel(AssetType type) {
    
    switch (type) {
    case AssetType.stocks:
      return "Stocks";
    case AssetType.mutualFund:
      return "Mutual Fund";
    case AssetType.gold:
      return "Gold";
    case AssetType.cash:
      return "Cash";
    case AssetType.crypto:
      return "Crypto";
    case AssetType.fixedDeposit:
      return "Fixed Deposit";
    case AssetType.property:
      return "Property";
    }
  }

  // Groups mockAssets by type and returns {type: totalValue}
  Map<AssetType, double> _groupByType(List<Asset> assets) {
    final map = <AssetType, double>{};
    for (final a in assets) {
      map[a.type] = (map[a.type] ?? 0) + a.currentValue;
    }
    return map;
  }

  String _formatMoney(double value) {
    return NumberFormat("#,##0.00", "en_US").format(value);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByType(portfolio.assets);
    final total = grouped.values.fold<double>(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildNetWorthCard(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildAssetsBreakdown(grouped, total),
            const SizedBox(height: 20),
            _buildNetWorthTrend(),
            const SizedBox(height: 20),
            _buildRecentTransactions(),
            const SizedBox(height: 90),
          ],
        ),
      ),
      
    );
  }

  Widget _buildHeader() {
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
              Text(
                "Hello, ${user.name.split(' ').first}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Text(
                "WealthWise",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Serif",
                ),
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
                decoration: const BoxDecoration(
                  color: _gold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNetWorthCard() {
    final spots = netWorthHistory
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _purple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    "Total Net Worth",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.visibility_outlined,
                      color: Colors.white70, size: 16),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text("This Month",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    Icon(Icons.keyboard_arrow_down,
                        color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "\$ ",
                  style: TextStyle(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: dashboard.totalNetWorth.toStringAsFixed(0),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 14),
              const SizedBox(width: 4),
              Text(
                "${dashboard.monthlyGrowth.toStringAsFixed(2)}%",
                style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
              ),
              const SizedBox(width: 6),
              const Text(
                "vs last month",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: _gold,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [_gold.withOpacity(0.3), _purple.withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      ("Add Asset", Icons.account_balance_wallet, _gold),
      ("Transfer", Icons.swap_horiz, _purple),
      ("Reports", Icons.pie_chart_outline, _teal),
      ("Goals", Icons.flag_outlined, _coral),
    ];

    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: (a.$3 as Color).withOpacity(0.15),
                      child: Icon(a.$2 as IconData, color: a.$3 as Color, size: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(a.$1 as String,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAssetsBreakdown(Map<AssetType, double> grouped, double total) {
    final entries = grouped.entries.toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Assets Breakdown",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 45,
                sections: entries.map((e) {
                  final pct = total == 0 ? 0 : (e.value / total) * 100;
                  return PieChartSectionData(
                    value: e.value,
                    color: _colorForType(e.key),
                    radius: 28,
                    showTitle: false,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...entries.map((e) {
            final pct = total == 0 ? 0.0 : (e.value / total) * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _colorForType(e.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_typeLabel(e.key),
                        style: const TextStyle(fontSize: 14)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("\$ ${_formatMoney(e.value)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      Text("${pct.toStringAsFixed(0)}%",
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNetWorthTrend() {
    final spots = netWorthHistory
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Net Worth Trend",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text("6 Months", style: TextStyle(fontSize: 12)),
                    Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("\$ ${dashboard.totalNetWorth.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
              Text(" ${dashboard.monthlyGrowth.toStringAsFixed(2)}%",
                  style: const TextStyle(color: Colors.green, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= netWorthHistory.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(netWorthHistory[i].month,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: _purple,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [_purple.withOpacity(0.15), _purple.withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Transactions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("View All",
                  style: TextStyle(
                      color: _purple, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          ...mockActivities.map((activity) {
            final amountColor = activity.isExpense ? Colors.redAccent : Colors.green;
            final sign = activity.isExpense ? "-" : "+";
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: amountColor.withOpacity(0.15),
                    child: Icon(
                      activity.isExpense
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: amountColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(
                          "${activity.subtitle} · ${DateFormat('MMM d, yyyy').format(activity.date)}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "$sign\$ ${_formatMoney(activity.amount)}",
                    style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
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

  

  