import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DesignStudioScreen extends StatefulWidget {
  final String? selectedProductName;

  const DesignStudioScreen({
    super.key,
    this.selectedProductName,
  });

  @override
  State<DesignStudioScreen> createState() => _DesignStudioScreenState();
}

class _DesignStudioScreenState extends State<DesignStudioScreen> {
  late String selectedProduct;
  String selectedColor = 'Wine';
  String selectedPattern = 'Classic';
  bool addNameTag = false;
  final TextEditingController notesController = TextEditingController();

  final productOptions = [
    'Tote Bag',
    'Laptop Sleeve',
    'Table Runner',
    'Round Mat',
    'Pouch',
  ];

  final colorOptions = ['Wine', 'Sand', 'Olive', 'Gold', 'Berry'];
  final patternOptions = ['Classic', 'Diamond', 'Wave', 'Modern'];

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.selectedProductName ?? 'Tote Bag';
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Studio')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'Live Design Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _DropdownField(
            label: 'Product Type',
            value: selectedProduct,
            items: productOptions,
            onChanged: (value) {
              setState(() => selectedProduct = value!);
            },
          ),
          const SizedBox(height: 12),
          _DropdownField(
            label: 'Color Palette',
            value: selectedColor,
            items: colorOptions,
            onChanged: (value) {
              setState(() => selectedColor = value!);
            },
          ),
          const SizedBox(height: 12),
          _DropdownField(
            label: 'Pattern',
            value: selectedPattern,
            items: patternOptions,
            onChanged: (value) {
              setState(() => selectedPattern = value!);
            },
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: addNameTag,
            onChanged: (value) {
              setState(() => addNameTag = value);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.border),
            ),
            title: const Text('Add personalization'),
            subtitle: const Text('Mock name tag / monogram feature'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add preferred motif, handle type, notes for artisan...',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Design saved'),
                  content: Text(
                    'Product: $selectedProduct\nColor: $selectedColor\nPattern: $selectedPattern\nPersonalization: ${addNameTag ? "Yes" : "No"}\n\nThis is a mock prototype action.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Save design'),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}