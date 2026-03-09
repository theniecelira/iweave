import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ItineraryBuilderScreen extends StatefulWidget {
  const ItineraryBuilderScreen({super.key});

  @override
  State<ItineraryBuilderScreen> createState() =>
      _ItineraryBuilderScreenState();
}

class _ItineraryBuilderScreenState extends State<ItineraryBuilderScreen> {
  bool includeWeaving = true;
  bool includeTour = true;
  bool includeFoodStop = false;
  bool includeAccommodation = false;
  bool includeTransport = false;

  String selectedStay = 'Guesthouse';
  final stays = ['Guesthouse', 'Hotel', 'Homestay'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary Builder')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'Map Preview\n(Mock)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mutedText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _SwitchCard(
            title: 'Banig weaving experience',
            subtitle: 'Add a cultural immersion stop',
            value: includeWeaving,
            onChanged: (v) => setState(() => includeWeaving = v),
          ),
          _SwitchCard(
            title: 'Curated Basey tour',
            subtitle: 'Include a tour package',
            value: includeTour,
            onChanged: (v) => setState(() => includeTour = v),
          ),
          _SwitchCard(
            title: 'Food stop',
            subtitle: 'Add local dining suggestions',
            value: includeFoodStop,
            onChanged: (v) => setState(() => includeFoodStop = v),
          ),
          _SwitchCard(
            title: 'Accommodation referral',
            subtitle: 'Add mock stay recommendations',
            value: includeAccommodation,
            onChanged: (v) => setState(() => includeAccommodation = v),
          ),
          _SwitchCard(
            title: 'Transportation referral',
            subtitle: 'Add mock transport suggestions',
            value: includeTransport,
            onChanged: (v) => setState(() => includeTransport = v),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedStay,
              decoration: const InputDecoration(
                labelText: 'Preferred stay type',
                border: InputBorder.none,
                filled: false,
              ),
              items: stays
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedStay = value!);
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final picks = [
                if (includeWeaving) 'Banig weaving experience',
                if (includeTour) 'Curated tour',
                if (includeFoodStop) 'Food stop',
                if (includeAccommodation) 'Accommodation referral',
                if (includeTransport) 'Transport referral',
              ];

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Mock itinerary created'),
                  content: Text(
                    'Included:\n${picks.map((e) => '• $e').join('\n')}\n\nStay preference: $selectedStay',
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
            child: const Text('Generate itinerary'),
          ),
        ],
      ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}