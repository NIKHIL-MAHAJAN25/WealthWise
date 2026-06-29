import '../models/asset_type.dart';
import '../models/activity.dart';
import '../models/asset.dart';
import '../models/dashboard_data.dart';
import '../models/net_worth_points.dart';
import '../models/portfolio.dart';
import '../models/user.dart';

final user = UserModel(
  id: "U001",
  name: "Nikhil Mahajan",
  email: "nikhil@example.com",
);

final portfolio = Portfolio(
  assets: mockAssets,
);

final List<Asset> mockAssets = [
  Asset(
    id: "A001",
    name: "Apple Inc.",
    type: AssetType.stocks,
    currentValue: 185000,
    purchaseValue: 160000,
    quantity: 12,
    purchaseDate: DateTime(2024, 2, 10),
    notes: "Long term investment",
  ),

  Asset(
    id: "A002",
    name: "24K Gold",
    type: AssetType.gold,
    currentValue: 95000,
    purchaseValue: 82000,
    quantity: 120,
    purchaseDate: DateTime(2023, 8, 15),
  ),

  Asset(
    id: "A003",
    name: "Emergency Fund",
    type: AssetType.cash,
    currentValue: 50000,
    purchaseValue: 50000,
    quantity: 1,
    purchaseDate: DateTime(2025, 1, 1),
  ),

  Asset(
    id: "A004",
    name: "Bitcoin",
    type: AssetType.crypto,
    currentValue: 145000,
    purchaseValue: 110000,
    quantity: 0.02,
    purchaseDate: DateTime(2024, 6, 12),
  ),

  Asset(
    id: "A005",
    name: "SBI Fixed Deposit",
    type: AssetType.fixedDeposit,
    currentValue: 210000,
    purchaseValue: 200000,
    quantity: 1,
    purchaseDate: DateTime(2023, 4, 1),
  ),
];

final dashboard = DashboardSummary(
  totalNetWorth: 685000,

  monthlyGrowth: 8.4,

  topAsset: mockAssets.first,

  recentActivities: mockActivities,

  netWorthHistory: netWorthHistory,
);

final List<Activity> mockActivities = [
  Activity(
    title: "Added Gold",
    subtitle: "24K Gold",
    amount: 25000,
    date: DateTime.now().subtract(const Duration(days: 1)),
    isExpense: false,
  ),

  Activity(
    title: "Purchased Bitcoin",
    subtitle: "Crypto",
    amount: 45000,
    date: DateTime.now().subtract(const Duration(days: 4)),
    isExpense: false,
  ),

  Activity(
    title: "Created Fixed Deposit",
    subtitle: "SBI",
    amount: 200000,
    date: DateTime.now().subtract(const Duration(days: 8)),
    isExpense: false,
  ),

  Activity(
    title: "Updated Property Value",
    subtitle: "Manual Update",
    amount: 18000,
    date: DateTime.now().subtract(const Duration(days: 14)),
    isExpense: false,
  ),
];

final List<NetWorthPoint> netWorthHistory = [
  NetWorthPoint(month: "Jan", value: 420000),
  NetWorthPoint(month: "Feb", value: 450000),
  NetWorthPoint(month: "Mar", value: 470000),
  NetWorthPoint(month: "Apr", value: 510000),
  NetWorthPoint(month: "May", value: 590000),
  NetWorthPoint(month: "Jun", value: 685000),
];