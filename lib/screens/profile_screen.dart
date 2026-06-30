import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/asset_provider.dart';

// ── Theme constants (keep in sync with portfolio_widget.dart) ─────────────────

const Color kPurpleDark  = Color(0xFF2D1B69);
const Color kPurpleMid   = Color(0xFF3D2680);
const Color kAccent      = Color(0xFFF5A623);
const Color kGreen       = Color(0xFF4AC9A4);
const Color kBg          = Color(0xFFF8F7FC);
const Color kCardBg      = Color(0xFFFFFFFF);
const Color kTextPrimary = Color(0xFF1A1A2E);
const Color kTextSec     = Color(0xFF6B6B8A);

String _formatINR(double v) {
  if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(2)}L';
  if (v >= 1000)   return '₹${(v / 1000).toStringAsFixed(1)}K';
  return '₹${v.toStringAsFixed(0)}';
}

// ── Settings items (trimmed to: Personal Info, Notifications, Appearance, About) ──

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SettingsItem(this.icon, this.title, this.subtitle);
}

const _settingsItems = [
  _SettingsItem(Icons.person_outline_rounded,    'Personal Information', 'Update your personal details'),
  _SettingsItem(Icons.notifications_none_rounded,'Notifications',        'Manage notification preferences'),
  _SettingsItem(Icons.palette_outlined,          'Appearance',           'Theme, font & display options'),
  _SettingsItem(Icons.info_outline_rounded,      'About WealthWise',     'Version 1.0.0'),
];

// ── Profile Widget ────────────────────────────────────────────────────────────

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _hideNetWorth = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetProvider>().loadAssets();
    });
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: clear stored Spring Boot auth token here once that's wired up.
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssetProvider>();

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          // ── App bar (icons removed) ──
          SliverAppBar(
            backgroundColor: kBg,
            floating: true,
            elevation: 0,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: kTextPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ── User card ──
          SliverToBoxAdapter(child: _buildUserCard()),

          // ── Net worth card (real data) ──
          SliverToBoxAdapter(child: _buildNetWorthCard(provider)),

          // ── Settings list ──
          SliverToBoxAdapter(child: _buildSettingsList()),

          // ── Logout ──
          SliverToBoxAdapter(child: _buildLogout()),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── User card ──
  Widget _buildUserCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD8A8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: const ClipOval(
              child: _AvatarIllustration(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Hello, Nikhil ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('👋', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'nikhil@example.com',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('👑', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Text(
                        'Premium Member',
                        style: TextStyle(
                          color: kAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: Colors.white54, size: 20),
        ],
      ),
    );
  }

  // ── Net worth card — now driven by AssetProvider ──
  Widget _buildNetWorthCard(AssetProvider provider) {
    final totalNetWorth = provider.totalNetWorth;
    final gainPct = provider.gainPercentage;
    final gainAbs = provider.totalGain;
    final trend = provider.netWorthTrendMock; // reuse the mocked trend from dashboard

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Net Worth Summary',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _hideNetWorth = !_hideNetWorth),
                child: Icon(
                  _hideNetWorth ? Icons.visibility_off : Icons.visibility,
                  color: kTextSec,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _hideNetWorth ? '••••••' : _formatINR(totalNetWorth),
                      style: const TextStyle(
                        color: kTextPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          gainAbs >= 0
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: gainAbs >= 0 ? kGreen : Colors.redAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${gainPct.toStringAsFixed(1)}% (${gainAbs >= 0 ? '+' : ''}${_formatINR(gainAbs)})',
                          style: TextStyle(
                            color: gainAbs >= 0 ? kGreen : Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'overall gain/loss',
                      style: TextStyle(color: kTextSec, fontSize: 11),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 110, height: 50,
                child: CustomPaint(
                  painter: _SparklinePainter(values: trend),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Settings list ──
  Widget _buildSettingsList() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(_settingsItems.length, (i) {
          final item = _settingsItems[i];
          final isLast = i == _settingsItems.length - 1;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: kBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: kPurpleDark, size: 20),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(
                    color: kTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: const TextStyle(color: kTextSec, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: kTextSec, size: 20),
                onTap: () {},
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 72,
                  color: kBg,
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Logout — now functional ──
  Widget _buildLogout() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: GestureDetector(
          onTap: _handleLogout,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.logout_rounded, color: Colors.red, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sparkline painter — now takes raw values instead of _NetWorthPoint ────────

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  _SparklinePainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final range = maxV - minV == 0 ? 1.0 : maxV - minV;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = values.length == 1 ? 0.0 : (i / (values.length - 1)) * size.width;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [kGreen.withOpacity(0.3), kGreen.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = kGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple avatar illustration (no image dependency) ─────────────────────────

class _AvatarIllustration extends StatelessWidget {
  const _AvatarIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFD8A8),
      child: const Icon(Icons.person_rounded,
          color: Color(0xFF8B5E3C), size: 40),
    );
  }
}