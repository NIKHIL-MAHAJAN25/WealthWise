import 'activity.dart';
import 'asset.dart';
import 'net_worth_points.dart';

class DashboardSummary {
  final double totalNetWorth;

  final double monthlyGrowth;

  final Asset topAsset;

  final List<Activity> recentActivities;

  final List<NetWorthPoint> netWorthHistory;

  const DashboardSummary({
    required this.totalNetWorth,
    required this.monthlyGrowth,
    required this.topAsset,
    required this.recentActivities,
    required this.netWorthHistory,
  });
}