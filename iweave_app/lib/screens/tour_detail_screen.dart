import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/tour_package.dart';

class TourDetailScreen extends StatelessWidget {
  final TourPackage tour;

  const TourDetailScreen({
    super.key,
    required this.tour,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tour Details')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Image.network(
            tour.imageUrl,
            height: 280,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 280,
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
                  tour.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${tour.location} • ${tour.duration}',
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      tour.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      '₱${tour.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  tour.description,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Highlights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ...tour.highlights.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mock booking confirmed',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'You selected: ${tour.title}\nReferral price: ₱${tour.price.toStringAsFixed(0)}',
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'This prototype uses a mock booking referral flow. Later, this can connect to partner schedules, transport, and payments.',
                              style: TextStyle(
                                color: AppColors.mutedText,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Done'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: const Text('Book / Refer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}