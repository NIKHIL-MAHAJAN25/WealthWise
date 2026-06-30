import 'package:flutter/material.dart';
import 'package:wealthwise/screens/add_asset.dart';
import 'insights.dart';
import 'portfolio_screen.dart';
import 'profile_screen.dart';
import 'dashboard_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex=0;
  final List<Widget> screens = [
    const DashBoardWidget(),
    const PortfolioWidget(),
    const InsightsWidget(),
    const ProfileWidget(),

  ];
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: _buildBottomNav(),
    );
  }
  Widget _buildBottomNav() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: const BoxDecoration(
      color: Color(0xFFFFFBF5),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(0, Icons.home_outlined, Icons.home, "Dashboard"),
        _navItem(1, Icons.account_balance_wallet_outlined,
            Icons.account_balance_wallet, "Portfolio"),
        _centerFab(),
        _navItem(2, Icons.trending_up_outlined, Icons.trending_up, "Insights"),
        _navItem(3, Icons.person_outline, Icons.person, "Profile"),
      ],
    ),
  );
}

Widget _navItem(int index, IconData icon, IconData selectedIcon, String label) {
  final isSelected = selectedIndex == index;
  return GestureDetector(
    onTap: () => setState(() => selectedIndex = index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? const Color(0xFF2E1A3C) : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? const Color(0xFF2E1A3C) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Widget _centerFab() {
  return GestureDetector(
    onTap: () {
       Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddAssetScreen(),
                    ),
                    );
    },
    child: Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFE4B429),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    ),
  );
}
}