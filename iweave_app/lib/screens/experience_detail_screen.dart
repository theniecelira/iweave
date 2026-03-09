import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  final Experience exp;

  const ExperienceDetailScreen({
    super.key,
    required this.exp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cultural Experience')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Image.network(
            exp.imageUrl,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 300,
              color: AppColors.border,
              child: const Icon(Icons.image_not_supported_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${exp.duration} • ₱${exp.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  exp.shortDescription,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 20),
                const Text(
                  'What to expect',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                ...exp.inclusions.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            color: AppColors.success, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mock experience booking started'),
                      ),
                    );
                  },
                  child: const Text('Book this experience'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}