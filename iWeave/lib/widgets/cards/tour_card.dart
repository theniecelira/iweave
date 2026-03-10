import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/tour_model.dart';
import '../../providers/tour_provider.dart';
import '../../core/utils/formatters.dart';

class TourCard extends StatelessWidget {
  final TourModel tour;
  final VoidCallback? onTap;

  const TourCard({super.key, required this.tour, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusL),
                    topRight: Radius.circular(AppDimensions.radiusL),
                  ),
                  child: Image.network(
                    tour.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150, color: AppColors.tagBg,
                      child: const Icon(Icons.image_not_supported, color: AppColors.textHint),
                    ),
                  ),
                ),
                if (tour.isTouristFavorite)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite_rounded, size: 10, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Tourist Favorite', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => context.read<TourProvider>().toggleTourFavorite(tour.id),
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                      ),
                      child: Icon(
                        tour.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16, color: tour.isFavorite ? AppColors.primary : AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.star.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(children: [
                          const Icon(Icons.star_rounded, size: 12, color: AppColors.star),
                          const SizedBox(width: 2),
                          Text('${tour.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        ]),
                      ),
                      const SizedBox(width: 6),
                      Text('${tour.reviewCount} reviews', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('${tour.durationDays} ${tour.durationDays == 1 ? 'day' : 'days'}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const Spacer(),
                      if (tour.originalPrice > 0)
                        Text(AppFormatters.currency(tour.originalPrice),
                          style: const TextStyle(
                            fontSize: 10, color: AppColors.textHint,
                            decoration: TextDecoration.lineThrough,
                          )),
                      const SizedBox(width: 2),
                      Text(AppFormatters.currency(tour.price),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final AccommodationModel accommodation;
  final VoidCallback? onTap;
  const AccommodationCard({super.key, required this.accommodation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusL),
                topRight: Radius.circular(AppDimensions.radiusL),
              ),
              child: Image.network(
                accommodation.imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 130, color: AppColors.tagBg),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.star_rounded, size: 13, color: AppColors.star),
                    const SizedBox(width: 2),
                    Text('${accommodation.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (accommodation.amenities.contains('WiFi'))
                      const Icon(Icons.wifi_rounded, size: 14, color: AppColors.textSecondary),
                  ]),
                  const SizedBox(height: 4),
                  Text(accommodation.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(accommodation.type,
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Text(AppFormatters.currency(accommodation.pricePerNight),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const Text(' /night', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
