import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/asset.dart';
import '../providers/asset_provider.dart';
import '../screens/asset_type_ui.dart';

class RemoveAssetScreen extends StatefulWidget {
  const RemoveAssetScreen({super.key});

  @override
  State<RemoveAssetScreen> createState() => _RemoveAssetScreenState();
}

class _RemoveAssetScreenState extends State<RemoveAssetScreen> {
  static const Color cream = Color(0xFFFAF6EC);
  static const Color darkGreen = Color(0xFF1F4D2C);
  static const Color textGrey = Color(0xFF6E6E6E);
  static const Color borderGrey = Color(0xFFDDD9CC);
  static const Color fieldFill = Color(0xFFF5F2E8);

  Asset? selectedAsset;
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  double get _perUnitValue {
    if (selectedAsset == null || selectedAsset!.quantity == 0) return 0;
    return selectedAsset!.currentValue / selectedAsset!.quantity;
  }

  Future<void> _handleRemove() async {
    if (selectedAsset == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select an asset to remove.")),
      );
      return;
    }

    final qty = double.tryParse(_quantityController.text.trim());
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid quantity.")),
      );
      return;
    }

    if (qty > selectedAsset!.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can't remove more than you hold.")),
      );
      return;
    }

    await context.read<AssetProvider>().removeAssetQuantity(selectedAsset!, qty);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Asset updated.")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final assets = context.watch<AssetProvider>().assets;

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Remove Asset",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECT HOLDING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: textGrey,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: assets.isEmpty
                    ? const Center(
                        child: Text(
                          "No assets to remove.",
                          style: TextStyle(color: textGrey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: assets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final asset = assets[i];
                          final isSelected = selectedAsset?.id == asset.id;

                          return GestureDetector(
                            onTap: () => setState(() {
                              selectedAsset = asset;
                              _quantityController.clear();
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? darkGreen.withOpacity(0.07)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? darkGreen : borderGrey,
                                  width: isSelected ? 1.6 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(asset.type.icon, color: asset.type.color, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          asset.name,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Holding: ${asset.quantity} · ₹ ${asset.currentValue.toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 12, color: textGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle, color: darkGreen, size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (selectedAsset != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'QUANTITY TO REMOVE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: fieldFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderGrey),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.remove_circle_outline, size: 18, color: textGrey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(fontSize: 14.5),
                          decoration: InputDecoration(
                            hintText: "Max ${selectedAsset!.quantity}",
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  final qty = double.tryParse(_quantityController.text.trim());
                  final valuePreview =
                      (qty != null && qty > 0 && qty <= selectedAsset!.quantity)
                          ? _perUnitValue * qty
                          : 0.0;
                  return Text(
                    "Estimated value removed: ₹ ${valuePreview.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 13, color: textGrey),
                  );
                }),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _handleRemove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: const Text(
                      'Remove Asset',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}