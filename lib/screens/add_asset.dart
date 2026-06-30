// add_asset_screen.dart
//
// "Add Asset" form screen for WealthWise — wired up to your existing
// Asset / AssetType models instead of inline strings.
//
// pubspec.yaml:
//   dependencies:
//     flutter_svg: ^2.0.10+1
//
//   flutter:
//     assets:
//       - assets/images/add_asset_illustration.svg

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/asset.dart';
import '../models/asset_type.dart';

class AddAssetScreen extends StatefulWidget {
  /// Called with the newly built [Asset] when the user taps Save.
  /// If null, the screen just pops with the asset as the result.
  final void Function(Asset asset)? onSave;

  const AddAssetScreen({super.key, this.onSave});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  static const Color cream = Color(0xFFFAF6EC);
  static const Color darkGreen = Color(0xFF1F4D2C);
  static const Color midGreen = Color(0xFF4C7A4F);
  static const Color textGrey = Color(0xFF6E6E6E);
  static const Color borderGrey = Color(0xFFDDD9CC);
  static const Color fieldFill = Color(0xFFF5F2E8);

  final _formKey = GlobalKey<FormState>();

  AssetType selectedType = AssetType.stocks;
  DateTime purchaseDate = DateTime(2024, 6, 7);

  final _assetNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _purchaseValueController = TextEditingController();
  final _currentValueController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _assetNameController.dispose();
    _quantityController.dispose();
    _purchaseValueController.dispose();
    _currentValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => purchaseDate = picked);
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
  }

  void _handleSave() {
    final name = _assetNameController.text.trim();
    final quantity = double.tryParse(_quantityController.text.trim());
    final purchaseValue = double.tryParse(_purchaseValueController.text.trim());
    final currentValue = double.tryParse(_currentValueController.text.trim());

    if (name.isEmpty || quantity == null || purchaseValue == null || currentValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields correctly.')),
      );
      return;
    }

    final asset = Asset(
      id: 'A${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: selectedType,
      currentValue: currentValue,
      purchaseValue: purchaseValue,
      quantity: quantity,
      purchaseDate: purchaseDate,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    if (widget.onSave != null) {
      widget.onSave!(asset);
    } else {
      Navigator.of(context).pop(asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // close button
             
              const SizedBox(height: 12),

              // header row: title/subtitle + illustration
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Asset',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add your asset details to track your net worth accurately.',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: textGrey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // illustration placeholder — drop your SVG into
                  // assets/images/add_asset_illustration.svg
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 130,
                      child: SvgPicture.asset(
                        'assets/images/add_asset_illustration.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ASSET TYPE
              _SectionLabel('ASSET TYPE'),
              const SizedBox(height: 10),
              _AssetTypeGrid(
                selected: selectedType,
                onSelect: (type) => setState(() => selectedType = type),
                darkGreen: darkGreen,
                borderGrey: borderGrey,
              ),
              const SizedBox(height: 22),

              // ASSET NAME
              _SectionLabel('ASSET NAME'),
              const SizedBox(height: 8),
              _InputField(
                controller: _assetNameController,
                hint: 'e.g. Apple Inc. (AAPL)',
                prefixIcon: Icons.apartment,
                fieldFill: fieldFill,
                borderGrey: borderGrey,
                textGrey: textGrey,
              ),
              const SizedBox(height: 18),

              // QUANTITY / PURCHASE DATE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('QUANTITY'),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _quantityController,
                          hint: 'e.g. 10',
                          prefixIcon: Icons.tag,
                          fieldFill: fieldFill,
                          borderGrey: borderGrey,
                          textGrey: textGrey,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('PURCHASE DATE'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: fieldFill,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderGrey),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    size: 18, color: darkGreen),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _formatDate(purchaseDate),
                                    style: const TextStyle(fontSize: 14.5),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: textGrey, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // PURCHASE VALUE / CURRENT VALUE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('PURCHASE VALUE'),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _purchaseValueController,
                          hint: 'e.g. 10000.00',
                          prefixIcon: Icons.currency_rupee,
                          fieldFill: fieldFill,
                          borderGrey: borderGrey,
                          textGrey: textGrey,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('CURRENT VALUE'),
                        const SizedBox(height: 8),
                        _InputField(
                          controller: _currentValueController,
                          hint: 'e.g. 12000.00',
                          prefixIcon: Icons.currency_rupee,
                          fieldFill: fieldFill,
                          borderGrey: borderGrey,
                          textGrey: textGrey,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // info banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: midGreen.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: midGreen.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.trending_up, color: darkGreen, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profit / Loss will be calculated automatically',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Based on current and purchase value',
                            style: TextStyle(fontSize: 12, color: textGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // NOTES
              _SectionLabel('NOTES (OPTIONAL)'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: fieldFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderGrey),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.description_outlined, size: 18, color: textGrey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _notesController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14.5),
                        decoration: InputDecoration(
                          hintText: 'Add any notes about this asset...',
                          hintStyle: TextStyle(color: textGrey.withOpacity(0.8)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Save Asset button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save_outlined, color: Colors.white, size: 20),
                  label: const Text(
                    'Save Asset',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: darkGreen, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// UI metadata (label / icon / color) for each [AssetType].
/// Keep this in sync if you add new enum values.
class AssetTypeUi {
  final String label;
  final IconData icon;
  final Color color;
  const AssetTypeUi(this.label, this.icon, this.color);
}

const Map<AssetType, AssetTypeUi> assetTypeUiMap = {
  AssetType.stocks: AssetTypeUi('Stocks', Icons.show_chart, Color(0xFF1F4D2C)),
  AssetType.mutualFund: AssetTypeUi('Mutual Fund', Icons.pie_chart, Color(0xFF555555)),
  AssetType.gold: AssetTypeUi('Gold', Icons.fitness_center, Color(0xFFD9A441)),
  AssetType.cash: AssetTypeUi('Cash', Icons.account_balance_wallet, Color(0xFF555555)),
  AssetType.crypto: AssetTypeUi('Crypto', Icons.currency_bitcoin, Color(0xFFE8A33D)),
  AssetType.fixedDeposit:
      AssetTypeUi('Fixed Deposit', Icons.account_balance, Color(0xFF6C5CE7)),
  AssetType.property: AssetTypeUi('Property', Icons.home, Color(0xFF2D9CDB)),
};

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: Color(0xFF6E6E6E),
      ),
    );
  }
}

class _AssetTypeGrid extends StatelessWidget {
  final AssetType selected;
  final ValueChanged<AssetType> onSelect;
  final Color darkGreen;
  final Color borderGrey;

  const _AssetTypeGrid({
    required this.selected,
    required this.onSelect,
    required this.darkGreen,
    required this.borderGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: AssetType.values.map((type) {
        final ui = assetTypeUiMap[type]!;
        final isSelected = type == selected;
        return GestureDetector(
          onTap: () => onSelect(type),
          child: Container(
            width: (MediaQuery.of(context).size.width - 40 - 30) / 4,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? darkGreen.withOpacity(0.07) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? darkGreen : borderGrey,
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(ui.icon, color: ui.color, size: 22),
                    const SizedBox(height: 8),
                    Text(
                      ui.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? darkGreen : Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final Color fieldFill;
  final Color borderGrey;
  final Color textGrey;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    required this.fieldFill,
    required this.borderGrey,
    required this.textGrey,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: fieldFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderGrey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(prefixIcon, size: 18, color: textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14.5),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: textGrey.withOpacity(0.8)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}