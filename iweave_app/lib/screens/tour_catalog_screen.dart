import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/tour_card.dart';
import 'tour_detail_screen.dart';

class TourCatalogScreen extends StatelessWidget {
  const TourCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tours = MockDataService.tours;
                          
    return Scaffold(
      appBar: AppBar(title: const Text('Curated Tours')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: tours.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const CustomSearchBar(
              hint: 'Search tours and attractions',
            );
          }

          final tour = tours[index - 1];
          return TourCard(
            tour: tour,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourDetailScreen(tour: tour),
                ),
              );
            },
          );
        },
      ),
    );
  }
}